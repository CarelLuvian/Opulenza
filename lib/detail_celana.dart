import 'package:flutter/material.dart';
import 'wishlist.dart';
import 'report_pembelian.dart';
import 'list_item.dart';
import 'review.dart'; // Tambahan import

class DetailCelanaPage extends StatefulWidget {
  final String name;
  final String price;
  final List<String> images;

  const DetailCelanaPage({
    super.key,
    required this.name,
    required this.price,
    required this.images,
  });

  @override
  State<DetailCelanaPage> createState() => _DetailCelanaPageState();
}

class _DetailCelanaPageState extends State<DetailCelanaPage> {
  int selectedIndex = 0;
  bool isFavorite = false;
  int quantity = 1;

  String? selectedSize;
  String? selectedColor;
  String? selectedMaterial;

  List<String> sizes = ['30', '31', '32', '33', '34', '35'];
  List<String> colors = ['Merah', 'Biru', 'Hitam', 'Putih', 'Abu-abu'];
  List<String> materials = ['Cotton', 'Tidak Cotton'];

  void addToWishlist() {
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  void _buyItem() {
    final int parsedPrice =
        int.tryParse(widget.price.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewPage(
          category: 'Celana',
          itemName: widget.name,
          itemPrice: parsedPrice,
          quantity: quantity,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // Gambar utama dan tombol
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Image.asset(
                  widget.images[selectedIndex],
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              SafeArea(
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon:
                        const Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () {
                          Navigator.pop(context);
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

          // Gambar thumbnail
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.images.length, (index) {
                final isSelected = selectedIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    width: isSelected ? 60 : 40,
                    height: isSelected ? 60 : 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey),
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

          // Detail Card
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nama dan Harga
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(widget.name,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(widget.price,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Size dan Jumlah
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedSize,
                            hint: const Text('Size'),
                            items: sizes
                                .map((size) => DropdownMenuItem(
                              value: size,
                              child: Text(size),
                            ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedSize = value;
                              });
                            },
                            decoration: InputDecoration(
                              contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          height: 56,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
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
                              Text(quantity.toString(),
                                  style: const TextStyle(fontSize: 16)),
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
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Color dan Bahan
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedColor,
                            hint: const Text('Color'),
                            items: colors
                                .map((color) => DropdownMenuItem(
                              value: color,
                              child: Text(color),
                            ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedColor = value;
                              });
                            },
                            decoration: InputDecoration(
                              contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedMaterial,
                            hint: const Text('Bahan'),
                            items: materials
                                .map((mat) => DropdownMenuItem(
                              value: mat,
                              child: Text(mat),
                            ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedMaterial = value;
                              });
                            },
                            decoration: InputDecoration(
                              contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Tombol Beli
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        onPressed: _buyItem,
                        icon: const Icon(Icons.add_box_outlined),
                        label: const Text('Beli'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          side: const BorderSide(color: Colors.black),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 20),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
