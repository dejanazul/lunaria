import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsApiService {
  static const String _apiKey = 'e5b4a531188b43cba462643a9664e050';
  static const String _baseUrl = 'https://newsapi.org/v2/everything';

  /// Fetches English sport/health/women news with broader, more relevant results.
  /// [keywords] is a list of search terms, e.g. ['sport', 'health', 'women']
  /// Returns a list of articles (Map) or throws an error.
  static Future<List<Map<String, dynamic>>> fetchArticles({
    List<String>? keywords,
    int pageSize = 20,
    int page = 1,
    String language = 'en',
    String? country,
  }) async {
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

    final response = await http.get(url);
    print('NewsAPI URL: $url');
    print('NewsAPI response: ${response.body}');
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'ok' && data['articles'] != null) {
        return List<Map<String, dynamic>>.from(data['articles']);
      } else {
        throw Exception('No articles found');
      }
    } else {
      throw Exception('Failed to fetch articles: ${response.statusCode}');
    }
  }
}
