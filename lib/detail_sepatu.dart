import 'package:flutter/material.dart';
import 'package:opulenza/report_pembelian.dart';
import 'list_item.dart';
import 'wishlist.dart';
import 'review.dart'; // Tambahkan ini

class DetailSepatuPage extends StatefulWidget {
  final String name;
  final String price;
  final List<String> images;

  const DetailSepatuPage({
    super.key,
    required this.name,
    required this.price,
    required this.images,
  });

  @override
  State<DetailSepatuPage> createState() => _DetailSepatuPageState();
}

class _DetailSepatuPageState extends State<DetailSepatuPage> {
  int selectedImageIndex = 0;
  int? selectedSize;
  bool isFavorite = false;
  int quantity = 1; // Tambahkan quantity

  final List<int> availableSizes = [5, 6, 7, 8, 9];

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
      // Simpan ke wishlist.dart jika perlu
    });
  }

  void _buyItem() {
    final int parsedPrice = int.tryParse(widget.price.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewPage(
          category: 'Sepatu',
          itemName: widget.name,
          itemPrice: parsedPrice,
          quantity: quantity,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final background = widget.images.isNotEmpty
        ? widget.images[selectedImageIndex]
        : 'assets/default.png';

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(background),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Top bar
          Positioned(
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
                      MaterialPageRoute(builder: (_) => const ListItemPage(category: 'sepatu')),
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
          ),

          // Image carousel
          Align(
            alignment: Alignment.center,
            child: Container(
              margin: const EdgeInsets.only(top: 270),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(16),
              ),
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.images.asMap().entries.map((entry) {
                  final index = entry.key;
                  final image = entry.value;
                  final isSelected = index == selectedImageIndex;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedImageIndex = index;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      width: isSelected ? 70 : 50,
                      height: isSelected ? 70 : 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: AssetImage(image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Bottom detail card
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              height: 250,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Ukuran', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: availableSizes.map((size) {
                      final isSelected = selectedSize == size;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedSize = size;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.grey : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.black),
                          ),
                          child: Text(
                            size.toString(),
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  const Text('Deskripsi'),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.price, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Colors.black),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: _buyItem, // Ganti ke _buyItem
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
