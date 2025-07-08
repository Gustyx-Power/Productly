class Product {
  final int id;
  final String title;
  final String description;
  final int price;
  final String image;
  final String category;
  final String source; // ✅ NEW

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.image,
    required this.category,
    this.source = 'fakestore', // ✅ default value
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: json['price'],
      image: (json['images'] as List).isNotEmpty ? json['images'][0] : '',
      category: json['category']['name'],
      source: json['source'] ?? 'fakestore', // ✅ fallback for API data
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
}