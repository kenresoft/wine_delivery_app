import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wine_delivery_app/utils/constants.dart';

import '../utils/preferences.dart';

class StorageRepository {
  const StorageRepository();

  final _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  Future<void> saveTokens(String accessToken, String refreshToken) async {
    setAuthToken = accessToken;
    // await _storage.write(key: 'accessToken', value: accessToken);
    await _storage.write(key: 'refreshToken', value: refreshToken);
  }

  Future<String> getAccessToken() async {
    return await authToken;
    // return await _storage.read(key: 'accessToken') ?? Constants.empty;
  }

  Future<String> getRefreshToken() async {
    return await _storage.read(key: 'refreshToken') ?? Constants.empty;
  }

  Future<void> clearTokens() async {
    await removeAuthToken();
    // await _storage.delete(key: 'accessToken');
    await _storage.delete(key: 'refreshToken');
  }
}

StorageRepository storageRepository = const StorageRepository();