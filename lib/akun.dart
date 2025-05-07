import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile.dart';

class AkunPage extends StatefulWidget {
  @override
  _AkunPageState createState() => _AkunPageState();
}

class _AkunPageState extends State<AkunPage> {
  String username = 'Guest';
  int postCount = 0;
  int opzCredit = 0;
  int sellerCredit = 0;
  int opzPoint = 0;

  int _selectedIndex = 3;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if (userId != null) {
      DatabaseReference dbRef = FirebaseDatabase.instance.ref("users/$userId");
      final snapshot = await dbRef.get();
      final data = snapshot.value as Map?;

      if (data != null) {
        setState(() {
          username = data['name'] ?? 'Guest';
          opzCredit = data['credit'] ?? 0;
          sellerCredit = data['sellerCredit'] ?? 0;
          opzPoint = data['points'] ?? 0;
          postCount = data['postCount'] ?? 0;
        });
      } else {
        // fallback ke local
        setState(() {
          username = prefs.getString('username') ?? 'Guest';
          opzCredit = prefs.getInt('opzCredit') ?? 0;
          sellerCredit = prefs.getInt('sellerCredit') ?? 0;
          opzPoint = prefs.getInt('opzPoint') ?? 0;
          postCount = prefs.getInt('postCount') ?? 0;
        });
      }
    }
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/explore');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/penjualan');
        break;
      case 3:
        break;
    }
  }

  void _editUsername() async {
    final newUsername = await showDialog<String>(
      context: context,
      builder: (context) {
        String tempName = username;
        return AlertDialog(
          title: Text('Ubah Username'),
          content: TextField(
            onChanged: (value) => tempName = value,
            controller: TextEditingController(text: username),
          ),
          actions: [
            TextButton(
              child: Text('Batal'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text('Simpan'),
              onPressed: () => Navigator.pop(context, tempName),
            ),
          ],
        );
      },
    );

    if (newUsername != null && newUsername.trim().isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', newUsername.trim());
      setState(() => username = newUsername.trim());

      // Simpan juga ke Firebase
      String? userId = prefs.getString('userId');
      if (userId != null) {
        await FirebaseDatabase.instance.ref("users/$userId/name").set(newUsername.trim());
      }
    }
  }

  Widget _buildMenuItem(String title, VoidCallback onTap) {
    return ListTile(
      title: Text(title),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
      visualDensity: VisualDensity.compact,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: AssetImage('assets/avatar/avatar.png'),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(username, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                Text('Masuk dengan Google', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                Text('$postCount Post', style: TextStyle(fontSize: 12, color: Colors.grey)),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.edit, color: Color(0xFFB19174)),
                            onPressed: _editUsername,
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFB19174),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
                        },
                        child: Text('Lihat Profil Saya'),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          children: [
                            Icon(Icons.credit_card),
                            SizedBox(height: 4),
                            Text("Opz Credit"),
                            Text("Rp $opzCredit", style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          children: [
                            Icon(Icons.credit_card),
                            SizedBox(height: 4),
                            Text("Seller Credit"),
                            Text("Rp $sellerCredit", style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Card(
                child: ListTile(
                  title: Text("Opz Point"),
                  trailing: Text("OP $opzPoint", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              SizedBox(height: 16),
              Divider(),
              _buildMenuItem("Pembelian", () {
                Navigator.pushReplacementNamed(context, '/reportpembelian');
              }),
              _buildMenuItem("Penjualan", () {
                Navigator.pushReplacementNamed(context, '/reportpenjualan');
              }),
              _buildMenuItem("Voucher", () {
                Navigator.pushReplacementNamed(context, '/voucher');
              }),
              _buildMenuItem("Wishlist", () {
                Navigator.pushReplacementNamed(context, '/wishlist');
              }),
              _buildMenuItem("Pertemuanku", () {
                Navigator.pushReplacementNamed(context, '/pertemuanku');
              }),
              _buildMenuItem("Chat dengan Customer Service", () {
                Navigator.pushReplacementNamed(context, '/chatcs');
              }),
              Divider(),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text("Keluar"),
                onTap: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.clear();
                  Navigator.pushReplacementNamed(context, '/signin');
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Color(0xFFB19174),
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Jual'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Akun'),
        ],
      ),
    );
  }
}
