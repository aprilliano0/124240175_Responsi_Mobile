import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/app_constants.dart';
import '../models/product.dart';

class ApiService {
  Future<List<Product>> fetchProducts() async {
    final response = await http
        .get(Uri.parse(AppConstants.apiProductsUrl))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception(
        'Gagal memuat produk. Status code: ${response.statusCode}',
      );
    }

    final dynamic data = jsonDecode(response.body);
    if (data is! List) {
      throw const FormatException('Format daftar produk dari API tidak valid.');
    }
    return data
        .map((item) => Product.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Product> fetchProductById(int id) async {
    final response = await http
        .get(Uri.parse('${AppConstants.apiProductsUrl}$id'))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception(
        'Gagal memuat detail produk. Status code: ${response.statusCode}',
      );
    }

    final dynamic data = jsonDecode(response.body);
    if (data is! Map<String, dynamic>) {
      throw const FormatException('Format detail produk dari API tidak valid.');
    }
    return Product.fromJson(data);
  }
}
