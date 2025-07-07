class Product {
  final int id;
  final String title;
  final String description;
  final int price;
  final String image;
  final String category;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.image,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: json['price'],
      image: (json['images'] as List).isNotEmpty ? json['images'][0] : '',
      category: json['category']['name'],
    );
  }
}