import 'dart:convert';

import 'package:vintiora/core/storage/local_storage.dart';
import 'package:vintiora/core/storage/secure_storage.dart';
import 'package:vintiora/features/auth/data/models/auth_tokens_model.dart';
import 'package:vintiora/features/auth/data/models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);

  Future<void> cacheTokens(AuthTokensModel tokens);

  Future<UserModel?> getLastUser();

  Future<String?> getAccessToken();

  Future<String?> getRefreshToken();

  Future<void> clearUserData();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const String userKey = 'CACHED_USER';
  static const String accessTokenKey = 'CACHED_ACCESS_TOKEN';
  static const String refreshTokenKey = 'CACHED_REFRESH_TOKEN';

  AuthLocalDataSourceImpl();

  @override
  Future<void> cacheUser(UserModel user) {
    return LocalStorage.set<String>(
      userKey,
      jsonEncode(user.toJson()),
    );
  }

  @override
  Future<void> cacheTokens(AuthTokensModel tokens) async {
    // Store access token in regular local storage
    await LocalStorage.set<String>(
      accessTokenKey,
      tokens.accessToken,
    );

    // Store refresh token in secure storage
    await SecureStorage.set<String>(
      refreshTokenKey,
      tokens.refreshToken,
    );
  }

  @override
  Future<UserModel?> getLastUser() async {
    final jsonString = LocalStorage.get<String>(userKey);
    if (jsonString != null) {
      return UserModel.fromJson(jsonDecode(jsonString));
    }
    return null;
  }

  @override
  Future<String?> getAccessToken() async {
    return LocalStorage.get<String>(accessTokenKey);
  }

  @override
  Future<String?> getRefreshToken() async {
    return await SecureStorage.get<String>(refreshTokenKey);
  }

  @override
  Future<void> clearUserData() async {
    await LocalStorage.remove(userKey);
    await LocalStorage.remove(accessTokenKey);
    await SecureStorage.remove(refreshTokenKey);
  }
}
