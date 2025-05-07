import 'package:flutter/material.dart';
import 'model/item_model.dart';
import 'report_pembelian.dart';
import 'list_item.dart';
import 'wishlist.dart';
import 'reviewtersier.dart';

class DetailMobilPage extends StatefulWidget {
  final ItemModel item;
  final String name;
  final int price;
  final int horsepower;
  final int torque;
  final double? zeroToSixty;
  final List<String> image;

  const DetailMobilPage({
    super.key,
    required this.name,
    required this.price,
    required this.horsepower,
    required this.torque,
    required this.zeroToSixty,
    required this.image,
    required this.item,
  });

  @override
  State<DetailMobilPage> createState() => _DetailMobilPageState();
}

class _DetailMobilPageState extends State<DetailMobilPage> {
  bool isFavorite = false;
  String selectedTab = 'Detail';
  int selectedIndex = 0;

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  void addToPembelian() {
    final int parsedPrice = widget.item.price;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewTersierPage(
          category: 'Mobil',
          namaItem: widget.item.name,
          hargaItem: parsedPrice,
        ),
      ),
    );
  }

  void addToWishlist() {
    setState(() {
      isFavorite = !isFavorite;
      // Simpan ke wishlist jika diperlukan
    });
  }

  Widget _buildSpecCard(String title) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black12),
        ),
        child: Center(
          child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildTab(String title) {
    final isSelected = selectedTab == title;
    return GestureDetector(
      onTap: () => setState(() => selectedTab = title),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: 30,
              height: 2,
              color: isSelected ? Colors.black : Colors.transparent,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (selectedTab) {
      case 'Detail':
        return const Text("Detail spesifikasi lengkap mobil.");
      case 'Features':
        return const Text("Fitur canggih dan keamanan.");
      case 'Design':
        return const Text("Desain interior & eksterior.");
      case 'Price-map':
        return const Text("Perbandingan harga & lokasi.");
      default:
        return const SizedBox();
    }
  }

  Widget _buildBottomBuyBar() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Rp ${widget.price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: addToPembelian,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                side: const BorderSide(color: Colors.black),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Row(
                children: [
                  Icon(Icons.add, color: Colors.black),
                  SizedBox(width: 4),
                  Text('Beli', style: TextStyle(color: Colors.black)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          Column(
            children: [
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: Image.asset(
                      widget.image[selectedIndex],
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.black),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ListItemPage(category: 'kendaraan'),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.black,
                            ),
                            onPressed: addToWishlist,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                widget.name,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    _buildSpecCard('${widget.horsepower} HP'),
                    _buildSpecCard('${widget.torque} Nm'),
                    _buildSpecCard('${widget.zeroToSixty?.toStringAsFixed(1) ?? "-"} s'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildTab('Detail'),
                    _buildTab('Features'),
                    _buildTab('Design'),
                    _buildTab('Price-map'),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildTabContent(),
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
          _buildBottomBuyBar(),
        ],
      ),
    );
  }
}
