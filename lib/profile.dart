import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser;
  String fullName = 'Tidak Diketahui';
  String email = 'Tidak Diketahui';
  String phone = '-';
  String passwordPlaceholder = '●●●●●●●';
  String profileImage = 'assets/images/profile_cat.jpg';

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    if (user != null) {
      // Set default email
      setState(() {
        email = user!.email ?? 'Tidak Diketahui';
        profileImage = user!.photoURL ?? profileImage;
      });

      // Get from Firebase Realtime Database
      DatabaseReference dbRef = FirebaseDatabase.instance.ref("users/${user!.uid}");
      DatabaseEvent snapshot = await dbRef.once();
      final data = snapshot.snapshot.value as Map?;

      if (data != null) {
        setState(() {
          fullName = data["name"] ?? fullName;
          phone = data["phone"] ?? '-';
        });
      }

      // Get from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? savedPassword = prefs.getString('password');
      if (savedPassword != null && savedPassword.isNotEmpty) {
        setState(() {
          passwordPlaceholder = '●●●●●●●';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header Profile
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFFD5B8A2),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            padding: const EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 30),
            child: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/akun');
                      },
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const Spacer(),
                    const Text(
                      "Profile",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(flex: 2),
                  ],
                ),
                const SizedBox(height: 20),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: profileImage.startsWith('http')
                      ? NetworkImage(profileImage)
                      : AssetImage(profileImage) as ImageProvider,
                ),
                const SizedBox(height: 10),
                Text(
                  fullName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Nama Lengkap',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Email
          buildProfileCard(
            icon: Icons.email_outlined,
            title: 'Email',
            subtitle: email,
          ),

          // Phone
          buildProfileCard(
            icon: Icons.phone_outlined,
            title: 'Mobile',
            subtitle: phone,
          ),

          // Password
          buildProfileCard(
            icon: Icons.lock_outline,
            title: 'Password',
            subtitle: passwordPlaceholder,
          ),
        ],
      ),
    );
  }

  Widget buildProfileCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Colors.grey.shade300),
        ),
        child: ListTile(
          leading: Icon(icon, color: Colors.grey.shade800),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(subtitle),
        ),
      ),
    );
  }
}
