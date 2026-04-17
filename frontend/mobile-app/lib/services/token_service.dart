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
}