import 'dart:convert';

class CacheEntry<T> {
  final T data;
  final DateTime expiration;
  final DateTime createdAt;

  CacheEntry({
    required this.data,
    required this.expiration,
    required this.createdAt,
  });

  /// Factory method to create a CacheEntry with default expiration
  factory CacheEntry.withDefaultExpiration(T data, {int expirationInSeconds = 60 * 60 * 24 * 3}) {
    // factory CacheEntry.withDefaultExpiration(T data, {int expirationInSeconds = 3600}) {
    final now = DateTime.now();
    return CacheEntry(
      data: data,
      expiration: now.add(Duration(seconds: expirationInSeconds)),
      createdAt: now,
    );
  }

  /// Check if the cache entry has expired
  bool isExpired() {
    return DateTime.now().isAfter(expiration);
  }

  /// Serialize the CacheEntry to a JSON-compatible format
  Map<String, dynamic> toJson() {
    return {
      'data': jsonEncode(data), // Ensure data is properly encoded
      'expiration': expiration.millisecondsSinceEpoch,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  /// Deserialize a JSON-compatible format into a CacheEntry
  static CacheEntry<T> fromJson<T>(Map<String, dynamic> json, T Function(dynamic) dataParser) {
    return CacheEntry(
      data: dataParser(jsonDecode(json['data'])), // Ensure data is decoded properly
      expiration: DateTime.fromMillisecondsSinceEpoch(json['expiration']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
    );
  }
}
