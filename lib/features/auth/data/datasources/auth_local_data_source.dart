import 'dart:convert';

import 'package:vintiora/core/storage/local_storage.dart';

import '../models/auth_tokens_model.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);

  Future<void> cacheTokens(AuthTokensModel tokens);

  Future<UserModel?> getLastUser();

  Future<String?> getAccessToken();

  Future<String?> getRefreshToken();

  Future<void> clearUserData();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const String USER_KEY = 'CACHED_USER';
  static const String ACCESS_TOKEN_KEY = 'CACHED_ACCESS_TOKEN';
  static const String REFRESH_TOKEN_KEY = 'CACHED_REFRESH_TOKEN';

  AuthLocalDataSourceImpl();

  @override
  Future<void> cacheUser(UserModel user) {
    return LocalStorage.set<String>(
      USER_KEY,
      jsonEncode(user.toJson()),
    );
  }

  @override
  Future<void> cacheTokens(AuthTokensModel tokens) async {
    await LocalStorage.set<String>(
      ACCESS_TOKEN_KEY,
      tokens.accessToken,
    );

    await LocalStorage.set<String>(
      REFRESH_TOKEN_KEY,
      tokens.refreshToken,
    );
  }

  @override
  Future<UserModel?> getLastUser() async {
    final jsonString = LocalStorage.get<String>(USER_KEY);
    if (jsonString != null) {
      return UserModel.fromJson(jsonDecode(jsonString));
    }
    return null;
  }

  @override
  Future<String?> getAccessToken() async {
    return LocalStorage.get<String>(ACCESS_TOKEN_KEY);
  }

  @override
  Future<String?> getRefreshToken() async {
    return LocalStorage.get<String>(REFRESH_TOKEN_KEY);
  }

  @override
  Future<void> clearUserData() async {
    await LocalStorage.remove(USER_KEY);
    await LocalStorage.remove(ACCESS_TOKEN_KEY);
    await LocalStorage.remove(REFRESH_TOKEN_KEY);
  }
}
