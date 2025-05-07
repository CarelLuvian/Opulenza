import 'package:flutter/material.dart';
import 'package:opulenza/reviewtersier.dart'; // Ganti dari report_pembelian.dart ke reviewtersier.dart
import 'list_item.dart';
import 'wishlist.dart';
import '../model/item_model.dart';

class DetailPerhiasanPage extends StatefulWidget {
  final ItemModel item;

  const DetailPerhiasanPage({super.key, required this.item});

  @override
  State<DetailPerhiasanPage> createState() => _DetailPerhiasanPageState();
}

class _DetailPerhiasanPageState extends State<DetailPerhiasanPage> {
  int selectedImageIndex = 0;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.item.isFavorite;
  }

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
      widget.item.isFavorite = isFavorite;
      // TODO: Simpan ke wishlist.dart jika diperlukan
    });
  }

  void addToPembelian() {
    // Format harga ke integer
    final int parsedPrice = widget.item.price;

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

  @override
  Widget build(BuildContext context) {
    final background = widget.item.galleryImages.isNotEmpty
        ? widget.item.galleryImages[selectedImageIndex]
        : widget.item.image;

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
                      MaterialPageRoute(
                        builder: (_) =>
                        const ListItemPage(category: 'perhiasan'),
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
                children: widget.item.galleryImages
                    .asMap()
                    .entries
                    .map((entry) {
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Text(widget.item.name,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildDescCard(
                          Icons.diamond, '${widget.item.diamondKarat}K'),
                      const SizedBox(width: 10),
                      _buildDescCard(
                          Icons.account_balance, '${widget.item.goldKarat}K'),
                      const SizedBox(width: 10),
                      _buildDescCard(
                          Icons.swap_horiz, '${widget.item.diameter} cm'),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Rp ${widget.item.price.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Colors.black),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: addToPembelian,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8),
                          child: Column(
                            children: [
                              Icon(Icons.add, color: Colors.black),
                              SizedBox(height: 4),
                              Text('Beli',
                                  style: TextStyle(color: Colors.black)),
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

  Widget _buildDescCard(IconData icon, String label) {
    return Container(
      width: 70,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(icon, size: 24, color: Colors.black),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
