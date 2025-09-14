import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NewsApiService {
  static const String _apiKey = String.fromEnvironment('NEWS_API_KEY');
  static const String _baseUrl = String.fromEnvironment('NEWS_BASE_URL');

  static Future<Object> fetchArticles({
    List<String>? keywords,
    int pageSize = 20,
    int page = 1,
    String language = 'en',
    String? country,
  }) async {
    if (_apiKey.isEmpty) {
      return Text("There is no Article Available");
    }

    try {
      // NewsAPI top-headlines: use only q, language, country for broader results
      final query =
          (keywords != null && keywords.isNotEmpty)
              ? keywords.join(' OR ')
              : 'health OR sport OR women OR menstruation OR menstrual';
      final params = <String, String>{
        'apiKey': _apiKey,
        'pageSize': pageSize.toString(),
        'page': page.toString(),
        'language': language,
        'q': query,
        // 'sortBy': 'publishedAt', // optional: newest first
      };
      // 'country' is not supported in /everything
      final url = Uri.parse(_baseUrl).replace(queryParameters: params);

      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'User-Agent': 'LunariaApp/1.0',
        if (_apiKey.isNotEmpty) 'X-API-Key': _apiKey,
      };

      final response = await http.get(url, headers: headers);
      debugPrint('NewsAPI URL: $url');
      debugPrint('NewsAPI response status: ${response.statusCode}');
      debugPrint('NewsAPI response headers: ${response.headers}');
      debugPrint('NewsAPI response: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'ok' && data['articles'] != null) {
          return List<Map<String, dynamic>>.from(data['articles']);
        } else {
          throw Exception(
            'No articles found: ${data['message'] ?? 'Unknown error'}',
          );
        }
      } else {
        return Text("There is no Article Available");
      }
    } catch (e) {
      return Text("There is no Article Available");
    }
  }
}
