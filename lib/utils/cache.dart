abstract class Cache<T> {
  Cache._();

  Future<T> getCache(String key);

  Future<void> cache(String key, String cacheItem);

  Future<bool> hasCache(String key);

  Future<void> clearCache(String key);
}
