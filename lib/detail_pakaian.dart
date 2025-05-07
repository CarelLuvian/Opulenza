import 'package:flutter/material.dart';
import 'review.dart'; // Pastikan file ini ada di direktori yang sesuai

class DetailPakaianPage extends StatefulWidget {
  final String name;
  final String price;
  final List<String> images;

  const DetailPakaianPage({
    super.key,
    required this.name,
    required this.price,
    required this.images,
  });

  @override
  State<DetailPakaianPage> createState() => _DetailPakaianPageState();
}

class _DetailPakaianPageState extends State<DetailPakaianPage> {
  int selectedImageIndex = 0;
  bool isFavorite = false;
  int quantity = 1;
  String? selectedSize;
  String? selectedColor;
  String? selectedMaterial;

  final List<String> sizes = ['S', 'M', 'L', 'XL'];
  final List<String> colors = ['Merah', 'Biru', 'Hitam', 'Putih', 'Abu-abu'];
  final List<String> materials = ['Cotton', 'Tidak Cotton'];

  void _toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
    // TODO: Add to wishlist logic
  }

  void _buyItem() {
    final int parsedPrice = int.tryParse(widget.price.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewPage(
          category: 'Pakaian',
          itemName: widget.name,
          itemPrice: parsedPrice,
          quantity: quantity,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String backgroundImage = widget.images[selectedImageIndex];

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              backgroundImage,
              fit: BoxFit.cover,
            ),
          ),

          // Top bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.favorite,
                      color: isFavorite ? Colors.red : Colors.black,
                    ),
                    onPressed: _toggleFavorite,
                  ),
                ],
              ),
            ),
          ),

          // Bottom card
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Image carousel
                  SizedBox(
                    height: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(widget.images.length, (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedImageIndex = index;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            width: index == selectedImageIndex ? 60 : 40,
                            height: index == selectedImageIndex ? 60 : 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: AssetImage(widget.images[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Name and Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(
                        widget.price,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Size and Quantity
                  Row(
                    children: [
                      Expanded(
                        child: _buildDropdownCard(
                          label: 'Size',
                          value: selectedSize,
                          items: sizes,
                          onChanged: (val) => setState(() => selectedSize = val),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  if (quantity > 1) {
                                    setState(() {
                                      quantity--;
                                    });
                                  }
                                },
                              ),
                              Text(quantity.toString(), style: const TextStyle(fontSize: 16)),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  setState(() {
                                    quantity++;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Color and Material
                  Row(
                    children: [
                      Expanded(
                        child: _buildDropdownCard(
                          label: 'Color',
                          value: selectedColor,
                          items: colors,
                          onChanged: (val) => setState(() => selectedColor = val),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildDropdownCard(
                          label: 'Bahan',
                          value: selectedMaterial,
                          items: materials,
                          onChanged: (val) => setState(() => selectedMaterial = val),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Buy button
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextButton.icon(
                        onPressed: _buyItem,
                        icon: const Icon(Icons.add_box_outlined),
                        label: const Text('Beli'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownCard({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(20),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(label),
          items: items.map((item) {
            return DropdownMenuItem(value: item, child: Text(item));
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
