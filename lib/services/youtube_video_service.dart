import 'dart:convert';
import 'package:http/http.dart' as http;

class YoutubeVideoService {
  static const String apiKey = 'YOUTUBE_API_KEY';

  static Future<List<Map<String, dynamic>>> fetchVideosByTag(String tag) async {
    final url =
        'https://www.googleapis.com/youtube/v3/search?part=snippet&type=video&maxResults=10&q=$tag&key=$apiKey';
    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);
    return (data['items'] as List)
        .map(
          (item) => {
            'id': item['id']['videoId'],
            'title': item['snippet']['title'],
            'thumbnail': item['snippet']['thumbnails']['high']['url'],
            'channel': item['snippet']['channelTitle'],
            'views': 30000, // Dummy views, replace with real if needed
            'isLocked': true,
            'isFavorite': false,
            'description': item['snippet']['description'],
            'chapters': [], // Fill with chapters if available
          },
        )
        .toList();
  }
}
