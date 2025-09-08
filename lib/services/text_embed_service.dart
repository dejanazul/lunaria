import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// Service untuk menghasilkan embedding dari teks menggunakan Hugging Face API
/// dengan model LazarusNLP/all-indo-e5-small-v4 (model bahasa Indonesia)
class TextEmbedService {
  /// API key untuk Hugging Face
  static const String apiKey = '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';

  /// Model embedding bahasa Indonesia
  static const String model = 'LazarusNLP/all-indo-e5-small-v4';

  /// URL endpoint Hugging Face
  static const String apiUrl =
      'https://api-inference.huggingface.co/models/$model';

  /// Menghasilkan embedding untuk teks input menggunakan Hugging Face API
  ///
  /// [input] - Teks yang akan dikonversi menjadi embedding vector
  ///
  /// Returns List<double> embedding vector atau empty list jika gagal
  static Future<List<double>> getEmbedding(String input) async {
    debugPrint('============= DEBUG: TEXT EMBEDDING =============');
    debugPrint('📝 Mulai proses embedding teks: "${input.substring(0, input.length > 50 ? 50 : input.length)}..."');
    debugPrint('📝 Model yang digunakan: $model');
    
    final Map<String, dynamic> payload = {
      'inputs': {
        "sentences": [input],
      },
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': "Bearer $apiKey",
          'Content-Type': 'application/json',
        },
        body: json.encode(payload),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        // Konversi embedding dari List<dynamic> ke List<double>
        final embeddings = List<double>.from(result[0]['embedding']);
        debugPrint('✅ Embedding berhasil dibuat: ${embeddings.length} dimensi');
        debugPrint('============= END EMBEDDING =============');
        return embeddings;
      } else {
        debugPrint(
          '❌ Failed to get embedding: ${response.statusCode}, ${response.body}',
        );
        debugPrint('============= END EMBEDDING (ERROR) =============');
        return [];
      }
    } catch (e) {
      debugPrint('❌ Error during embedding request: $e');
      debugPrint('============= END EMBEDDING (ERROR) =============');
      return [];
    }
  }
}
