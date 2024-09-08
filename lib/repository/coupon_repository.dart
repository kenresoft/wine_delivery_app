import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/coupon.dart';
import '../utils/constants.dart';
import 'auth_repository.dart';

class CouponRepository {
  CouponRepository._();

  static final CouponRepository _instance = CouponRepository._();

  static CouponRepository getInstance() {
    return _instance;
  }

  static const String _baseUrl = '${Constants.baseUrl}/api/coupon';

  Future<Coupon> createCoupon(
    String code,
    double discount,
    double minimumPurchaseAmount,
    DateTime expiryDate,
  ) async {
    final url = Uri.parse(_baseUrl);
    final body = jsonEncode({
      'code': code,
      'discount': discount,
      'minimumPurchaseAmount': minimumPurchaseAmount,
      'expiryDate': expiryDate.toString(),
    });

    try {
      final token = await authRepository.getAccessToken();
      final response = await http.post(
        url,
        body: body,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return Coupon.fromJson(data['coupon']);
      } else {
        throw Exception('Failed to create coupon: ${response.body}');
      }
    } on Exception catch (error) {
      throw Exception('Error creating coupon: $error');
    }
  }

  Future<List<Coupon>> getAllCoupons() async {
    final url = Uri.parse(_baseUrl);

    try {
      final token = await authRepository.getAccessToken();
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['coupons'] as List).map((coupon) => Coupon.fromJson(coupon)).toList();
      } else {
        throw Exception('Failed to get all coupons: ${response.body}');
      }
    } on Exception catch (error) {
      throw Exception('Error getting all coupons: $error');
    }
  }

  Future<Coupon?> getCouponByCode(String code) async {
    final url = Uri.parse('$_baseUrl/$code');

    try {
      final token = await authRepository.getAccessToken();
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Coupon.fromJson(data['coupon']);
      } else if (response.statusCode == 404) {
        // throw Exception('Coupon not found');
        return null;
      } else {
        throw Exception('Failed to get coupon by code: ${response.body}');
        // return null;
      }
    } on Exception catch (error) {
      throw Exception('Error getting coupon by code: $error');
    }
  }

  Future<Coupon> updateCoupon(
    String id,
    String code,
    double discount,
    double minimumPurchaseAmount,
    DateTime expiryDate,
  ) async {
    final url = Uri.parse('$_baseUrl/$id');
    final body = jsonEncode({
      'code': code,
      'discount': discount,
      'minimumPurchaseAmount': minimumPurchaseAmount,
      'expiryDate': expiryDate.toString(),
    });

    try {
      final token = await authRepository.getAccessToken();
      final response = await http.put(
        url,
        body: body,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Coupon.fromJson(data['coupon']);
      } else if (response.statusCode == 404) {
        throw Exception('Coupon not found');
      } else {
        throw Exception('Failed to update coupon: ${response.body}');
      }
    } on Exception catch (error) {
      throw Exception('Error updating coupon: $error');
    }
  }

  Future<void> deleteCoupon(String id) async {
    final url = Uri.parse('$_baseUrl/$id');

    try {
      final token = await authRepository.getAccessToken();
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 204) {
        return;
      } else if (response.statusCode == 404) {
        throw Exception('Coupon not found');
      } else {
        throw Exception('Failed to delete coupon: ${response.body}');
      }
    } on Exception catch (error) {
      throw Exception('Error deleting coupon: $error');
    }
  }
}

CouponRepository couponRepository = CouponRepository.getInstance();