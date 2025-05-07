// File: lib/ui/list_item.dart
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../model/item_model.dart';

class ListItemPage extends StatefulWidget {
  final String category;

  const ListItemPage({Key? key, required this.category}) : super(key: key);

  @override
  State<ListItemPage> createState() => _ListItemPageState();
}

class _ListItemPageState extends State<ListItemPage> {
  late final DatabaseReference _productsRef;
  late Future<List<ItemModel>> _itemsFuture;
  String selectedFilter = 'Terbaru';

  @override
  void initState() {
    super.initState();
    _productsRef = FirebaseDatabase.instance.ref('products');
    _loadItems();
  }

  void _loadItems() {
    _itemsFuture = _fetchItemsByCategory(widget.category);
  }

  Future<List<ItemModel>> _fetchItemsByCategory(String category) async {
    final snapshot = await _productsRef.orderByChild('category').equalTo(category).get();
    final list = snapshot.children.map(ItemModel.fromSnapshot).toList();
    for (var item in list) {
      item.isFavorite = await ItemModel.loadFavoriteStatus(item.id);
    }
    return list;
  }

  void applyFilter(List<ItemModel> items, String filter) {
    setState(() {
      selectedFilter = filter;
      switch (filter) {
        case 'Harga Termurah':
          items.sort((a, b) => a.price.compareTo(b.price));
          break;
        case 'Harga Tertinggi':
          items.sort((a, b) => b.price.compareTo(a.price));
          break;
        case 'Terbaru':
          items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          break;
        case 'Paling Diminati':
          items.shuffle();
          break;
      }
    });
  }

  void toggleFavorite(ItemModel item) async {
    await item.toggleFavorite(_productsRef);
    setState(() {});
  }

  void navigateToDetail(ItemModel item) {
    // Replace with specific detail page as needed
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailGenericPage(item: item),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => Navigator.pop(context)),
        title: Text(widget.category),
        actions: [
          DropdownButton<String>(
            value: selectedFilter,
            onChanged: (value) async {
              if (value != null) {
                final items = await _itemsFuture;
                applyFilter(items, value);
              }
            },
            items: ['Terbaru', 'Harga Termurah', 'Harga Tertinggi', 'Paling Diminati']
                .map((filter) => DropdownMenuItem(
              value: filter,
              child: Text(filter),
            ))
                .toList(),
          ),
        ],
      ),
      body: FutureBuilder<List<ItemModel>>(
        future: _itemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: \${snapshot.error}'));
          } else {
            final items = snapshot.data!;
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2 / 2.7,
              ),
              itemBuilder: (context, index) {
                final item = items[index];
                return GestureDetector(
                  onTap: () => navigateToDetail(item),
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                              child: Image.network(
                                item.image,
                                height: 120,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: IconButton(
                                icon: Icon(
                                  item.isFavorite ? Icons.favorite : Icons.favorite_border,
                                  color: item.isFavorite ? Colors.red : Colors.white,
                                ),
                                onPressed: () => toggleFavorite(item),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            item.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            'Rp \${item.price}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

/// Generic detail page placeholder
class DetailGenericPage extends StatelessWidget {
  final ItemModel item;

  const DetailGenericPage({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(item.name)),
    body: Center(child: Text('Detail for \${item.name}')),
  );
}
