import 'package:vintiora/core/storage/local_storage.dart';

abstract class CacheService {
  Future<dynamic> get(String key);

  Future<void> set(String key, dynamic data, {Duration? expiry});

  Future<void> remove(String key);

  Future<void> removeAll();

  Future<bool> isExpired(String key);
}

class CacheServiceImpl implements CacheService {
  CacheServiceImpl();

  @override
  Future<dynamic> get(String key) async {
    final data = await LocalStorage.get(key);
    if (data == null) return null;

    // Check expiration if available
    final expiryTimestamp = await LocalStorage.get('${key}_expiry');
    if (expiryTimestamp != null && DateTime.now().millisecondsSinceEpoch > expiryTimestamp) {
      await remove(key);
      await remove('${key}_expiry');
      return null;
    }
    return data;
  }

  @override
  Future<void> set(String key, dynamic data, {Duration? expiry}) async {
    await LocalStorage.set(key, data);
    if (expiry != null) {
      final expiryTimestamp = DateTime.now().add(expiry).millisecondsSinceEpoch;
      await LocalStorage.set('${key}_expiry', expiryTimestamp);
    }
  }

  @override
  Future<void> remove(String key) async {
    await LocalStorage.remove(key);
    await LocalStorage.remove('${key}_expiry');
  }

  @override
  Future<void> removeAll() async {
    // await LocalStorage.clearAll();
  }

  @override
  Future<bool> isExpired(String key) async {
    final expiryTimestamp = await LocalStorage.get('${key}_expiry');
    if (expiryTimestamp == null) return false;
    return DateTime.now().millisecondsSinceEpoch > expiryTimestamp;
  }
}
