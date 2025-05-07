// File: lib/ui/home.dart
import 'package:flutter/material.dart';
import 'package:opulenza/akun.dart';
import 'package:opulenza/explore.dart';
import 'package:opulenza/pengajuan_penjualan.dart';
import 'package:opulenza/list_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final List<String> recentSearches = [];
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> categories = [
    {'label': 'Pakaian',     'icon': Icons.checkroom},
    {'label': 'Celana',      'icon': Icons.local_mall},
    {'label': 'Jam Tangan',  'icon': Icons.watch},
    {'label': 'Tas',         'icon': Icons.backpack},
    {'label': 'Sepatu',      'icon': Icons.directions_run},
    {'label': 'Perhiasan',   'icon': Icons.diamond},
    {'label': 'Kendaraan',   'icon': Icons.directions_car},
    {'label': 'Rumah',       'icon': Icons.home},
  ];

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);

    Widget page;
    switch (index) {
      case 1:
        page = const ExplorePage();
        break;
      case 2:
        page =  PengajuanPenjualanPage();
        break;
      case 3:
        page = AkunPage();
        break;
      default:
        page = const HomePage();
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, animation, __, child) {
          final offsetAnimation = animation.drive(
            Tween(begin: const Offset(1.0, 0.0), end: Offset.zero),
          );
          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );
  }

  void _handleSearch(String query) {
    if (query.trim().isEmpty) return;
    setState(() {
      recentSearches.remove(query);
      recentSearches.insert(0, query);
    });
    _searchController.clear();
  }

  void _clearSearches() {
    setState(() {
      recentSearches.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showRecentSearch =
        _searchController.text.isNotEmpty && recentSearches.isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // HEADER + SEARCH
              Stack(
                children: [
                  Image.asset(
                    'Assets/Background/background_home.png',
                    fit: BoxFit.cover,
                    height: 180,
                    width: double.infinity,
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'OPULENZA',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: const CircleAvatar(
                                backgroundColor: Color(0xFFB19174),
                                child: Icon(Icons.shopping_bag_outlined,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            _buildSearchField(),
                            const SizedBox(height: 10),
                            if (showRecentSearch) _buildRecentSearches(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // GRID KATEGORI
              _buildCategoryGrid(),

              const SizedBox(height: 20),

              // SECTIONS
              _buildSection(title: 'Pakaian'),
              _buildSection(title: 'Celana'),
              _buildSection(title: 'Jam Tangan'),
              _buildSection(title: 'Tas'),
              _buildSection(title: 'Sepatu'),
              _buildSection(title: 'Perhiasan'),
              _buildSection(title: 'Kendaraan'),
              _buildSection(title: 'Rumah'),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFFB19174),
        unselectedItemColor: const Color(0xFF6C757D),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.sell), label: 'Penjualan'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Akun'),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      onSubmitted: _handleSearch,
      decoration: InputDecoration(
        hintText: 'Cari Produk',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildRecentSearches() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Pencarian terakhirmu',
                style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: recentSearches
                  .map((item) => Chip(
                  label: Text(item),
                  backgroundColor: const Color(0xFFEFEFEF)))
                  .toList(),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: _clearSearches,
                icon: const Icon(Icons.delete, size: 18),
                label: const Text('Hapus Pencarian'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: categories.map((category) {
          final label = category['label'] as String;
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      ListItemPage(category: label.toLowerCase()),
                ),
              );
            },
            child: Container(
              width: MediaQuery.of(context).size.width / 4 - 18,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(category['icon'], color: const Color(0xFFB19174), size: 28),
                  const SizedBox(height: 6),
                  Text(label,
                      style: const TextStyle(fontSize: 12),
                      textAlign: TextAlign.center),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSection({required String title}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ListItemPage(category: title.toLowerCase()),
                    ),
                  );
                },
                child: const Text('Lihat Semua'),
              ),
            ],
          ),
        ),
        // Placeholder: bisa Anda ganti dengan preview horizontal ListView
        SizedBox(
          height: 120,
          child: Center(
            // remove const so $title works
            child: Text('Preview produk $title'),
          ),
        ),
      ],
    );
  }
}
