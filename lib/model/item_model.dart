// File: lib/model/item_model.dart
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Model class for items in Opulenza marketplace
class ItemModel {
  /// Unique identifier (key) from Firebase Realtime Database
  final String id;

  final String name;
  final String brand;
  final String description;
  final String location;
  String category;
  final int horsepower;
  final int torque;
  final double? zeroToSixty;
  final int diameter;
  final int goldKarat;
  final int diamondKarat;
  final int price;
  final String image;
  final List<String> galleryImages;
  bool isFavorite;
  int createdAt;

  ItemModel({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    // category dan createdAt kini optional dengan default
    this.category = '',
    this.createdAt = 0,
    this.brand = '',
    this.description = '',
    this.location = '',
    this.horsepower = 0,
    this.torque = 0,
    this.zeroToSixty,
    this.diameter = 0,
    this.goldKarat = 0,
    this.diamondKarat = 0,
    this.galleryImages = const [],
    this.isFavorite = false,
  });

  /// Creates an ItemModel from a Firebase snapshot
  factory ItemModel.fromSnapshot(DataSnapshot snapshot) {
    final map = Map<String, dynamic>.from(snapshot.value as Map<dynamic, dynamic>);
    return ItemModel(
      id: snapshot.key!,
      name: map['name'] as String? ?? '',
      price: map['price'] as int? ?? 0,
      image: map['image'] as String? ?? '',
      category: map['category'] as String? ?? '',
      createdAt: map['createdAt'] as int? ?? 0,
      brand: map['brand'] as String? ?? '',
      description: map['description'] as String? ?? '',
      location: map['location'] as String? ?? '',
      horsepower: map['horsepower'] as int? ?? 0,
      torque: map['torque'] as int? ?? 0,
      zeroToSixty: (map['zeroToSixty'] as num?)?.toDouble(),
      diameter: map['diameter'] as int? ?? 0,
      goldKarat: map['goldKarat'] as int? ?? 0,
      diamondKarat: map['diamondKarat'] as int? ?? 0,
      galleryImages: (map['galleryImages'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
          [],
      isFavorite: map['isFavorite'] as bool? ?? false,
    );
  }

  /// Converts this model into a Map for writing to Firebase or export
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'brand': brand,
      'description': description,
      'location': location,
      'horsepower': horsepower,
      'torque': torque,
      'zeroToSixty': zeroToSixty,
      'diameter': diameter,
      'goldKarat': goldKarat,
      'diamondKarat': diamondKarat,
      'price': price,
      'image': image,
      'galleryImages': galleryImages,
      'isFavorite': isFavorite,
      'createdAt': createdAt,
    };
  }

  /// Save favorite status to SharedPreferences
  static Future<void> saveFavoriteStatus(String itemId, bool isFav) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('favorite_$itemId', isFav);
  }

  /// Load favorite status from SharedPreferences
  static Future<bool> loadFavoriteStatus(String itemId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('favorite_$itemId') ?? false;
  }

  /// Toggle favorite status and persist both in Firebase and locally
  Future<void> toggleFavorite(DatabaseReference ref) async {
    isFavorite = !isFavorite;
    // Update di Firebase
    await ref.child(id).update({'isFavorite': isFavorite});
    // Persist secara lokal
    await saveFavoriteStatus(id, isFavorite);
  }
}
