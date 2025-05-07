import 'package:flutter/material.dart';

class WishlistPage extends StatefulWidget {
  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  List<Map<String, dynamic>> wishlist = []; // Akan diisi saat user klik favorite

  void _goBack() {
    Navigator.pushReplacementNamed(context, '/akun');
  }

  void _filterAndSort() {
    // Tambahkan logic filter & sort di sini
    print('Filter & Urutkan clicked');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wishlist', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: _goBack,
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 70),
            child: wishlist.isEmpty
                ? Center(child: Text('Belum ada wishlist.'))
                : ListView.builder(
              itemCount: wishlist.length,
              itemBuilder: (context, index) {
                final item = wishlist[index];
                return ListTile(
                  title: Text(item['nama']),
                  subtitle: Text(item['harga'].toString()),
                  trailing: Icon(Icons.favorite, color: Colors.red),
                );
              },
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: _filterAndSort,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFB99272), // warna coklat sesuai gambar
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                'Filter & Urutkan',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
