import 'package:extensionresoft/extensionresoft.dart';
import 'package:wine_delivery_app/utils/extensions.dart';

class CacheRepository {
  CacheRepository._();

  static final CacheRepository _instance = CacheRepository._();

  static CacheRepository getInstance() => _instance;

  Future<void> cache(String key, String? body) async {
    await SharedPreferencesService.setString(key, body ?? '');
  }

  Future<String> getCache(String key) async {
    return SharedPreferencesService.getString(key) ?? '';
  }

  Future<bool> hasCache(String key) async {
    return SharedPreferencesService.containsKey(key) && !(await getCache(key)).isNullOrEmpty;
  }

  Future<void> clearCache(String key) async {
    await SharedPreferencesService.remove(key);
  }
}

final CacheRepository cacheRepository = CacheRepository.getInstance();
