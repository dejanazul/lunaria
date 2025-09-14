import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsApiService {
  static const String _apiKey = String.fromEnvironment('NEWS_API_KEY');
  static const String _baseUrl = String.fromEnvironment('NEWS_BASE_URL');

  static Future<List<Map<String, dynamic>>> fetchArticles({
    List<String>? keywords,
    int pageSize = 20,
    int page = 1,
    String language = 'en',
    String? country,
  }) async {
    if (_apiKey.isEmpty) {
      // Jika tidak ada API key, return fallback data
      return _getFallbackArticles();
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
      print('NewsAPI URL: $url');
      print('NewsAPI response status: ${response.statusCode}');
      print('NewsAPI response headers: ${response.headers}');
      print('NewsAPI response: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'ok' && data['articles'] != null) {
          return List<Map<String, dynamic>>.from(data['articles']);
        } else {
          throw Exception(
            'No articles found: ${data['message'] ?? 'Unknown error'}',
          );
        }
      } else if (response.statusCode == 429) {
        throw Exception('Rate limit exceeded. Please try again later.');
      } else if (response.statusCode == 401) {
        throw Exception('Invalid API key. Please check your NEWS_API_KEY.');
      } else if (response.statusCode == 400) {
        throw Exception('Bad request. Please check your parameters.');
      } else {
        throw Exception(
          'Failed to fetch articles: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      if (e.toString().contains('CORS') ||
          e.toString().contains('XMLHttpRequest') ||
          e.toString().contains('Access-Control-Allow-Origin') ||
          e.toString().contains('No \'Access-Control-Allow-Origin\' header')) {
        print('CORS error detected, using fallback articles...');
        return _getFallbackArticles();
      } else if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        throw Exception(
          'Network error: Please check your internet connection.',
        );
      } else {
        print('API error: $e');
        // Untuk error lainnya, juga gunakan fallback
        return _getFallbackArticles();
      }
    }
  }

  // Method untuk menyediakan artikel fallback ketika API gagal
  static List<Map<String, dynamic>> _getFallbackArticles() {
    return [
      {
        'title': 'Benefits of Regular Exercise for Women\'s Health',
        'description':
            'Discover how regular physical activity can improve women\'s overall health and wellbeing, including hormonal balance and mental health.',
        'url': 'https://example.com/article1',
        'urlToImage':
            'https://via.placeholder.com/300x200?text=Exercise+Benefits',
        'publishedAt':
            DateTime.now().subtract(Duration(hours: 2)).toIso8601String(),
        'source': {'name': 'Health Magazine'},
      },
      {
        'title': 'Understanding Menstrual Cycle and Exercise',
        'description':
            'Learn how to adapt your workout routine based on your menstrual cycle phases for optimal performance and comfort.',
        'url': 'https://example.com/article2',
        'urlToImage':
            'https://via.placeholder.com/300x200?text=Menstrual+Cycle',
        'publishedAt':
            DateTime.now().subtract(Duration(hours: 6)).toIso8601String(),
        'source': {'name': 'Women\'s Fitness'},
      },
      {
        'title': 'Yoga and Mindfulness for Better Sleep',
        'description':
            'Explore gentle yoga practices and mindfulness techniques that can help improve your sleep quality naturally.',
        'url': 'https://example.com/article3',
        'urlToImage': 'https://via.placeholder.com/300x200?text=Yoga+Sleep',
        'publishedAt':
            DateTime.now().subtract(Duration(hours: 12)).toIso8601String(),
        'source': {'name': 'Wellness Today'},
      },
    ];
  }
}
