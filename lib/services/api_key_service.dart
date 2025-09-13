import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiKeyService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );
  static const String _geminiApiKeyKey = String.fromEnvironment(
    "GEMINI_API_KEY",
  );
  static Future<void> saveGeminiApiKey(String apiKey) async {
    await _storage.write(key: _geminiApiKeyKey, value: apiKey);
  }

  static Future<String> getGeminiApiKey() async {
    return _geminiApiKeyKey;
  }

  static Future<bool> hasCustomApiKey() async {
    final apiKey = await _storage.read(key: _geminiApiKeyKey);
    return apiKey != null && apiKey.isNotEmpty;
  }

  static Future<void> removeGeminiApiKey() async {
    await _storage.delete(key: _geminiApiKeyKey);
  }
}
