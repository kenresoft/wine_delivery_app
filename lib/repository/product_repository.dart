import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/product.dart';

class ProductRepository {
  ProductRepository._(this.baseUrl);

  static final ProductRepository _instance = ProductRepository._('http://192.168.67.207:3333');

  // Getter for the singleton instance
  static ProductRepository getInstance() {
    return _instance;
  }

  final String baseUrl;

  ProductRepository({required this.baseUrl});

  Future<List<Product>> getAllProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/api/products'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['products'];
      return data.map((productJson) => Product.fromJson(productJson)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<Product> getProductById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/api/products/$id'));

    if (response.statusCode == 200) {
      return Product.fromJson(json.decode(response.body)['product']);
    } else {
      throw Exception('Failed to load product');
    }
  }

  Future<Product> createProduct(Product product) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/products'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': product.name,
        'category': product.category.id,
        'image': product.image,
        'price': product.price,
        'alcoholContent': product.alcoholContent,
        'description': product.description,
      }),
    );

    if (response.statusCode == 201) {
      return Product.fromJson(json.decode(response.body)['product']);
    } else {
      throw Exception('Failed to create product');
    }
  }

  Future<Product> updateProduct(String id, Product product) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/products/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': product.name,
        'category': product.category.id,
        'image': product.image,
        'price': product.price,
        'alcoholContent': product.alcoholContent,
        'description': product.description,
      }),
    );

    if (response.statusCode == 200) {
      return Product.fromJson(json.decode(response.body)['product']);
    } else {
      throw Exception('Failed to update product');
    }
  }

  Future<void> deleteProduct(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/api/products/$id'));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete product');
    }
  }
}

final ProductRepository productManager = ProductRepository.getInstance();
