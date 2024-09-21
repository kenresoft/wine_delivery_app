import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:wine_delivery_app/repository/decision_repository.dart';

import '../model/product.dart';
import '../utils/constants.dart';
import '../utils/enums.dart';
import '../utils/utils.dart';

class ProductRepository {
  ProductRepository._();

  static final ProductRepository _instance = ProductRepository._();

  static ProductRepository getInstance() {
    return _instance;
  }

  ProductRepository();

  Future<List<Product>> getAllProducts() async {

    try {
      final response = await Utils.makeRequest('${Constants.baseUrl}/api/products');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['products'];
        return data.map((productJson) => Product.fromJson(productJson)).toList();
      } else {
        //throw Exception('Failed to load products');
        return [];
      }
    } on Exception {
      return [];
    }
  }

  Future<List<Product>> getProductsByIds(List<String> ids) async {
    try {
      // Join the list of IDs with a comma
      final idsParam = ids.join(',');
      final response = await Utils.makeRequest('${Constants.baseUrl}/api/products/ids/$idsParam');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Check if 'products' key exists in the response
        if (data['products'] != null) {
          final productsList = data['products'] as List<dynamic>;

          // Map each product JSON object to a Product model
          final products = productsList.map((productData) {
            return Product.fromJson(productData as Map<String, dynamic>);
          }).toList();

          return products;
        } else {
          throw 'Error: "products" key not found in response.';
        }
      }

      if (response.statusCode == 401) {
        throw 'Unauthorized: Please log in again.';
      }

      throw 'Error fetching user favorites: ${response.statusCode} - ${response.reasonPhrase}';
    } catch (e) {
      throw 'ERROR: $e';
    }
  }

  Future<Product> getProductById(String id) async {
    return decisionRepository.decide(
      cacheKey: 'getProductById:$id',
      endpoint: '${Constants.baseUrl}/api/products/$id',
      onSuccess: (data) async {
        if (data['product'] != null) {
          final productData = data['product'] as Map<String, dynamic>;
          //logger.d(productData);
          return Product.fromJson(productData);
        } else {
          throw 'Error: Product not found in response.';
        }
      },
      onError: ( error) async {
        logger.e('ERROR: ${error.toString()}');
        return Product.empty();
      },
    );
    /*try {
      final response = await Utils.makeRequest('${Constants.baseUrl}/api/products/$id');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

      }

      if (response.statusCode == 401) {
        throw 'Unauthorized: Please log in again.';
      }

      throw 'Error fetching user favorites: ${response.statusCode} - ${response.reasonPhrase}';
    } catch (e) {
      throw 'ERROR: $e';
    }*/
  }

  Future<Product> createProduct(Product product) async {
    final response = await Utils.makeRequest('${Constants.baseUrl}/api/products',
        method: RequestMethod.post,
        body: json.encode({
          'name': product.name,
          'category': product.category.id,
          'image': product.image,
          'price': product.price,
          'alcoholContent': product.alcoholContent,
          'description': product.description,
        }));

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

final ProductRepository productRepository = ProductRepository.getInstance();
