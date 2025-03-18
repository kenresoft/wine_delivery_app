import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  SecureStorage._();

  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      resetOnError: true,
      keyCipherAlgorithm: KeyCipherAlgorithm.RSA_ECB_OAEPwithSHA_256andMGF1Padding,
      storageCipherAlgorithm: StorageCipherAlgorithm.AES_GCM_NoPadding,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
      synchronizable: false,
    ),
  );

  // Type identifier constants for serialization
  static const String _typeString = 'string';
  static const String _typeBool = 'bool';
  static const String _typeInt = 'int';
  static const String _typeDouble = 'double';
  static const String _typeMap = 'map';
  static const String _typeList = 'list';

  static Future<void> init() async {}

  static Future<void> set<T>(String key, T value) async {
    if (value == null) {
      await remove(key);
      return;
    }

    String serializedValue;
    String typeIdentifier;

    if (value is String) {
      serializedValue = value;
      typeIdentifier = _typeString;
    } else if (value is bool) {
      serializedValue = value.toString();
      typeIdentifier = _typeBool;
    } else if (value is int) {
      serializedValue = value.toString();
      typeIdentifier = _typeInt;
    } else if (value is double) {
      serializedValue = value.toString();
      typeIdentifier = _typeDouble;
    } else if (value is Map) {
      serializedValue = jsonEncode(value);
      typeIdentifier = _typeMap;
    } else if (value is List) {
      serializedValue = jsonEncode(value);
      typeIdentifier = _typeList;
    } else {
      throw UnsupportedError('Type ${T.toString()} is not supported by SecureStorage');
    }

    // Store the value with type information for proper deserialization
    final encodedValue = jsonEncode({
      'type': typeIdentifier,
      'value': serializedValue,
    });

    await _storage.write(key: key, value: encodedValue);
  }

  static Future<T?> get<T>(String key) async {
    final encodedValue = await _storage.read(key: key);
    if (encodedValue == null) return null;

    try {
      final Map<String, dynamic> decodedData = jsonDecode(encodedValue);
      final String typeIdentifier = decodedData['type'];
      final dynamic rawValue = decodedData['value'];

      switch (typeIdentifier) {
        case _typeString:
          return rawValue as T;
        case _typeBool:
          return (rawValue.toLowerCase() == 'true') as T;
        case _typeInt:
          return int.parse(rawValue) as T;
        case _typeDouble:
          return double.parse(rawValue) as T;
        case _typeMap:
          return jsonDecode(rawValue) as T;
        case _typeList:
          return jsonDecode(rawValue) as T;
        default:
          throw FormatException('Unknown type identifier: $typeIdentifier');
      }
    } catch (e) {
      // For backward compatibility or migration scenarios
      // Return the raw value as a fallback
      if (T == String) {
        return encodedValue as T;
      }
      return null;
    }
  }

  static Future<void> remove(String key) async => await _storage.delete(key: key);

  static Future<void> clear() async => await _storage.deleteAll();

  static Future<bool> containsKey(String key) async {
    final value = await _storage.read(key: key);
    return value != null;
  }

  static Future<Map<String, String>> getAll() async => await _storage.readAll();

  static Future<Set<String>> getAllKeys() async {
    final allValues = await _storage.readAll();
    return allValues.keys.toSet();
  }

  // Compile-time type safety for specific types
  static Future<String?> getString(String key) async => await get<String>(key);

  static Future<bool?> getBool(String key) async => await get<bool>(key);

  static Future<int?> getInt(String key) async => await get<int>(key);

  static Future<double?> getDouble(String key) async => await get<double>(key);

  static Future<Map<String, dynamic>?> getMap(String key) async => await get<Map<String, dynamic>>(key);

  static Future<List<dynamic>?> getList(String key) async => await get<List<dynamic>>(key);
}
