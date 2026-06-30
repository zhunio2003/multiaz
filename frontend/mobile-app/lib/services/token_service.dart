import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenService {
  final _storage = FlutterSecureStorage();

  Future<void> saveTokens(String accessToken, String refreshToken) async {
    await _storage.write(key: "accessToken", value: accessToken);
    await _storage.write(key: "refreshToken", value: refreshToken);
  }
  
  Future<String?> getAccessToken() {
    return _storage.read(key: "accessToken");
  }

  Future<String?> getRefreshToken() {
    return _storage.read(key: "refreshToken");
  }

  Future<String?> getUserId() async {
    final token = await getAccessToken();

    if (token == null) return null;

    final parts = token.split('.');

    if (parts.length != 3) return null;

    final payload = parts[1];

    final normalized = base64Url.normalize(payload);
    final decoded = utf8.decode(base64Url.decode(normalized));
    final map = json.decode(decoded) as Map<String, dynamic>;
    return map['sub'] as String?;

  }
}