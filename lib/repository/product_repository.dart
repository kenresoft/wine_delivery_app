import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/product.dart';
import '../utils/constants.dart';
import '../utils/prefs.dart';

class ProductRepository {
  ProductRepository._();

  static final ProductRepository _instance = ProductRepository._();

  // Getter for the singleton instance
  static ProductRepository getInstance() {
    return _instance;
  }

  ProductRepository();

  Future<List<Product>> getAllProducts() async {
    //final token = await authRepository.getToken();
    print(authToken);
    final response = await http.get(
      Uri.parse('${Constants.baseUrl}/api/products'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );

    try {
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['products'];
        return data.map((productJson) => Product.fromJson(productJson)).toList();
      } else {
        //throw Exception('Failed to load products');
        print(response.toString());
        return [];
      }
    } on Exception catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<Product> getProductById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/api/products/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );
      if (response.statusCode == 200) {
        print(json.decode(response.body)['product']);
        // final p = Product.fromJson(json.decode(response.body)['product']);
        final data = jsonDecode(response.body);
        if (data['product'] != null) {
          final productData = data['product'] as Map<String, dynamic>;
          return Product.fromJson(productData);
        } else {
          throw 'Error: Product not found in response.';
        }
        // return Product.fromJson(json.decode(response.body)['product']);
      }

      if (response.statusCode == 401) {
        throw 'Unauthorized: Please log in again.';
      }

      throw 'Error fetching user favorites: ${response.statusCode} - ${response.reasonPhrase}';
    } catch (e) {
      throw 'ERROR: $e';
    }
  }

  Future<Product> createProduct(Product product) async {
    final response = await http.post(
      Uri.parse('${Constants.baseUrl}/api/products'),
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
      Uri.parse('${Constants.baseUrl}/api/products/$id'),
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
    final response = await http.delete(Uri.parse('${Constants.baseUrl}/api/products/$id'));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete product');
    }
  }
}

final ProductRepository productManager = ProductRepository.getInstance();
