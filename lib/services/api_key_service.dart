import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiKeyService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  // Kunci untuk menyimpan API key di secure storage
  static const String _geminiApiKeyKey = 'gemini_api_key';

  // API Key default yang hardcoded
  static const String _defaultApiKey = 'GEMINI_API_KEY';

  static Future<void> saveGeminiApiKey(String apiKey) async {
    await _storage.write(key: _geminiApiKeyKey, value: apiKey);
  }

  static Future<String> getGeminiApiKey() async {
    // Selalu kembalikan default API key jika tidak ada yang disimpan
    return await _storage.read(key: _geminiApiKeyKey) ?? _defaultApiKey;
  }

  // Method ini masih berguna jika nanti ingin cek apakah user sudah custom API key
  static Future<bool> hasCustomApiKey() async {
    final apiKey = await _storage.read(key: _geminiApiKeyKey);
    return apiKey != null && apiKey.isNotEmpty;
  }

  static Future<void> removeGeminiApiKey() async {
    await _storage.delete(key: _geminiApiKeyKey);
  }
}
