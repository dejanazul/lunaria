import 'dart:convert';
import 'package:http/http.dart' as http;

class GitHubAIService {
  final String _baseUrl = 'https://models.github.ai/inference/chat/completions';
  final String _token = const String.fromEnvironment('GITHUB_API_KEY');

  Future<Map<String, dynamic>> chatCompletion({
    required List<Map<String, dynamic>> messages,
    String model = 'openai/gpt-5-mini',
  }) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
      body: jsonEncode({'messages': messages, 'model': model}),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to get completion: ${response.statusCode} ${response.body}',
      );
    }

    final Map<String, dynamic> data = jsonDecode(response.body);
    return data;
  }

  Future<String> sendMessage({
    required String userMessage,
    String systemMessage =
        'Kamu adalah ahli dalam menganalisis data menstruasi dan kesehatan reproduksi wanita.',
  }) async {
    final messages = <Map<String, dynamic>>[
      {'role': 'system', 'content': systemMessage},
      {'role': 'user', 'content': userMessage},
    ];

    final response = await chatCompletion(messages: messages);

    final choices = response['choices'];
    if (choices is List && choices.isNotEmpty) {
      final message = choices[0]["message"];
      if (message is Map && message['content'] is String) {
        return message['content'] as String;
      }
    }
    throw Exception('Unexpected response format: $response');
  }
}
