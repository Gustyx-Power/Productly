import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';
import '../utils/constants.dart';

class ApiService {
  static Future<List<Product>> fetchProducts() async {
    final url = Uri.parse('$kApiBaseUrl/products?limit=250');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Gagal memuat produk');
    }
  }
}