import 'package:extensionresoft/extensionresoft.dart';
import 'package:wine_delivery_app/utils/extensions.dart';

import 'cache.dart';

class CacheRepository implements Cache<String> {
  CacheRepository._();

  static final CacheRepository _instance = CacheRepository._();

  static CacheRepository getInstance() => _instance;

  @override
  Future<void> cache(String key, String? body) async {
    //final orderJsonList = orders.map((order) => jsonEncode(order.toJson())).toList();
    await SharedPreferencesService.setString(key, body ?? '');
  }

  @override
  Future<String> getCache(String key) async {
    return SharedPreferencesService.getString(key) ?? '';
    //return cachedOrders.map((orderJson) => Order.fromJson(jsonDecode(orderJson))).toList();
  }

  @override
  Future<bool> hasCache(String key) async {
    return SharedPreferencesService.containsKey(key) && !(await getCache(key)).isNullOrEmpty;
  }

  @override
  Future<void> clearCache(String key) async {
    await SharedPreferencesService.remove(key);
  }
}

final CacheRepository cacheRepository = CacheRepository.getInstance();
