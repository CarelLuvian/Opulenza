import 'package:flutter/material.dart';
import 'list_item.dart';
import 'wishlist.dart';
import 'report_pembelian.dart';
import 'reviewtersier.dart';

class DetailRumahPage extends StatefulWidget {
  final String name;
  final String location;
  final String description;
  final int price;
  final String galeryImages;


  const DetailRumahPage({
    super.key,
    required this.name,
    required this.location,
    required this.description,
    required this.price,
    required this.galeryImages,
  });

  @override
  State<DetailRumahPage> createState() => _DetailRumahPageState();
}

class _DetailRumahPageState extends State<DetailRumahPage> {
  bool isFavorite = false;

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
      // Tambahkan item ke wishlist.dart jika diperlukan
    });
  }

  void addToPembelian() {
    // Format harga ke integer
    final int parsedPrice = widget.price;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewTersierPage(
          category: 'Perhiasan',
          namaItem: widget.item.name,
          hargaItem: parsedPrice,
        ),
      ),
    );
  }

  Widget buildFacilityCard(IconData icon, String label) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(1, 1)),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget buildTopBar() {
    return Positioned(
      top: 40,
      left: 16,
      right: 16,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const ListItemPage(category: 'rumah'),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.black,
            ),
            onPressed: toggleFavorite,
          ),
        ],
      ),
    );
  }

  Widget buildBuyCard() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Rp ${widget.price.toString()}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ElevatedButton(
              onPressed: addToPembelian,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                side: const BorderSide(color: Colors.black),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Column(
                  children: [
                    Icon(Icons.add, color: Colors.black),
                    SizedBox(height: 4),
                    Text('Beli', style: TextStyle(color: Colors.black)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDetailCard() {
    return Positioned(
      bottom: 80,
      left: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(widget.location, style: const TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 4),
            Text(widget.description, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                buildFacilityCard(Icons.bed, 'Bedroom'),
                buildFacilityCard(Icons.bathtub, 'Restroom'),
                buildFacilityCard(Icons.wifi, 'WiFi'),
                buildFacilityCard(Icons.directions_car, 'Carport'),
                buildFacilityCard(Icons.home_work, '2 Lantai'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFEFEF),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.grey.shade300,
            child: const Center(child: Text("Gambar rumah di sini")),
          ),
          buildTopBar(),
          buildDetailCard(),
          buildBuyCard(),
        ],
      ),
    );
  }
}

extension on DetailRumahPage {
  get item => null;
}
