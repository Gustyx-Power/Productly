import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';
import '../models/product_model.dart';
import '../utils/constants.dart';

class ApiService {
  static Future<List<Product>> fetchProducts() async {
    final box = Hive.box('products');

    // Cek apakah sudah ada data cache
    if (box.containsKey('data')) {
      final raw = box.get('data');
      final List data = json.decode(raw);
      return data.map((e) => Product.fromJson(e)).toList();
    }

    // Kalau belum ada → fetch API
    return await _fetchAndCache();
  }

  static Future<List<Product>> refreshProducts() async {
    return await _fetchAndCache();
  }

  static Future<List<Product>> _fetchAndCache() async {
    try {
      final response = await http
          .get(Uri.parse('$kApiBaseUrl/products?limit=100'))
          .timeout(const Duration(seconds: 6));

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        final box = Hive.box('products');
        await box.put('data', json.encode(data));
        return data.map((e) => Product.fromJson(e)).toList();
      } else {
        throw Exception('API gagal: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Gagal fetch API: $e');
    }
  }
}