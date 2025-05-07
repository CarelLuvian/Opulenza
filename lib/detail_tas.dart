import 'package:flutter/material.dart';
import 'list_item.dart';
import 'wishlist.dart';
import 'report_pembelian.dart';
import 'review.dart'; // Tambahkan ini

class DetailTasPage extends StatefulWidget {
  final String name;
  final String price;
  final List<String> images;

  const DetailTasPage({
    super.key,
    required this.name,
    required this.price,
    required this.images,
  });

  @override
  State<DetailTasPage> createState() => _DetailTasPageState();
}

class _DetailTasPageState extends State<DetailTasPage> {
  bool isFavorite = false;
  int selectedImageIndex = 0;
  int quantity = 1;

  String? selectedSize;
  String? selectedColor;
  String? selectedBahan;

  final List<String> sizeOptions = ['S', 'M', 'L', 'XL'];
  final List<String> colorOptions = ['Merah', 'Biru', 'Hitam', 'Putih', 'Abu-abu'];
  final List<String> bahanOptions = ['Cotton', 'Tidak Cotton'];

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  void _buyItem() {
    final int parsedPrice = int.tryParse(widget.price.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewPage(
          category: 'Tas',
          itemName: widget.name,
          itemPrice: parsedPrice,
          quantity: quantity,
        ),
      ),
    );
  }

  void incrementQuantity() {
    setState(() {
      quantity++;
    });
  }

  void decrementQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
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
                  builder: (_) => const ListItemPage(category: 'tas'),
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

  Widget buildImageSelector() {
    return Positioned(
      top: 250,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(widget.images.length, (index) {
              double size = index == selectedImageIndex ? 70 : 50;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedImageIndex = index;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: size,
                  height: size,
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
      ),
    );
  }

  Widget buildDropdownCard(String label, List<String> options, String? selectedValue, Function(String?) onChanged) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(6),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black38),
          borderRadius: BorderRadius.circular(12),
        ),
        child: DropdownButton<String>(
          value: selectedValue,
          isExpanded: true,
          underline: const SizedBox(),
          hint: Text(label),
          items: options.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget buildQuantityCard() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(6),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black38),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(onPressed: decrementQuantity, icon: const Icon(Icons.remove)),
            Text('$quantity', style: const TextStyle(fontSize: 16)),
            IconButton(onPressed: incrementQuantity, icon: const Icon(Icons.add)),
          ],
        ),
      ),
    );
  }

  Widget buildBuyCard() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(widget.price, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                buildDropdownCard('Size', sizeOptions, selectedSize, (val) {
                  setState(() {
                    selectedSize = val;
                  });
                }),
                buildQuantityCard(),
              ],
            ),
            Row(
              children: [
                buildDropdownCard('Color', colorOptions, selectedColor, (val) {
                  setState(() {
                    selectedColor = val;
                  });
                }),
                buildDropdownCard('Bahan', bahanOptions, selectedBahan, (val) {
                  setState(() {
                    selectedBahan = val;
                  });
                }),
              ],
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: _buyItem,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Colors.black),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Column(
                    children: [
                      Icon(Icons.add, color: Colors.black),
                      SizedBox(height: 4),
                      Text('Beli', style: TextStyle(color: Colors.black)),
                    ],
                  ),
                ),
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
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(widget.images[selectedImageIndex]),
                fit: BoxFit.cover,
              ),
            ),
          ),
          buildTopBar(),
          buildImageSelector(),
          buildBuyCard(),
        ],
      ),
    );
  }
}
