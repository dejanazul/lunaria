import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TextEmbedService {
  static const String apiKey = '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';

  static const String apiUrl =
      "https://router.huggingface.co/hf-inference/models/LazarusNLP/all-indo-e5-small-v4/pipeline/feature-extraction";

   Future<List<double>> getEmbedding(String input) async {
    debugPrint('============= DEBUG: TEXT EMBEDDING =============');
    debugPrint(
      '📝 Mulai proses embedding teks: "${input.substring(0, input.length > 50 ? 50 : input.length)}..."',
    );
    debugPrint('📝 Model: LazarusNLP/all-indo-e5-small-v4');
    debugPrint('📝 Endpoint: feature-extraction');

    final Map<String, dynamic> payload = {'inputs': input};

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': "Bearer $apiKey",
          'Content-Type': 'application/json',
        },
        body: json.encode(payload),
      );

      debugPrint('📊 Response status: ${response.statusCode}');
      debugPrint(
        '📊 Response body preview: ${response.body.length > 200 ? response.body.substring(0, 200) + "..." : response.body}',
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);

        // Feature extraction mengembalikan array embeddings
        List<double> embeddings;
        if (result is List && result.isNotEmpty) {
          // Format bisa berupa nested array atau flat array
          embeddings = List<double>.from(result);
        } else {
          debugPrint('❌ Unexpected response format: $result');
          return [];
        }

        debugPrint('✅ Embedding berhasil dibuat: ${embeddings.length} dimensi');
        debugPrint('📊 Sample values: [${embeddings.take(5).join(", ")}...]');
        debugPrint('============= END EMBEDDING =============');
        return embeddings;
      } else {
        debugPrint('❌ HTTP Error: ${response.statusCode}');
        debugPrint('❌ Response: ${response.body}');
        debugPrint('============= END EMBEDDING (ERROR) =============');
        return [];
      }
    } catch (e) {
      debugPrint('❌ Exception: $e');
      debugPrint('============= END EMBEDDING (ERROR) =============');
      return [];
    }
  }
}
