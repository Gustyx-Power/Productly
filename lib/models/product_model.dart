import 'package:hive/hive.dart';

part 'product_model.g.dart';

@HiveType(typeId: 2) // Gunakan typeId unik, pastikan tidak bentrok
class Product {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final int price;

  @HiveField(4)
  final String image;

  @HiveField(5)
  final String category;

  @HiveField(6)
  final String source;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.image,
    required this.category,
    this.source = 'fakestore',
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: json['price'],
      image: (json['images'] as List).isNotEmpty ? json['images'][0] : '',
      category: json['category']['name'],
      source: json['source'] ?? 'fakestore',
    );
  }

  Product copyWith({
    int? id,
    String? title,
    String? description,
    int? price,
    String? image,
    String? category,
    String? source,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      image: image ?? this.image,
      category: category ?? this.category,
      source: source ?? this.source,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Product &&
        other.id == id &&
        other.title == title &&
        other.image == image &&
        other.source == source;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    title.hashCode ^
    image.hashCode ^
    source.hashCode;
  }
}