import 'package:lunaria/services/supabase_service.dart';
import 'package:lunaria/services/gemini_service.dart';
import 'package:flutter/foundation.dart';

class QAService {
  // Threshold untuk menentukan apakah hasil dari similarity search cukup relevan
  static const double RELEVANCE_THRESHOLD = 0.75;

  /// Mencari jawaban untuk pertanyaan user menggunakan RAG (Retrieval Augmented Generation)
  ///
  /// 1. Melakukan similarity search untuk mencari dokumen yang relevan
  /// 2. Jika ditemukan dokumen yang relevan, jawaban diambil dari dokumen tersebut
  /// 3. Jika tidak ditemukan dokumen yang relevan, menggunakan LLM untuk menjawab
  static Future<String> getAnswer({
    required String question,
    List<double>? embeddings,
  }) async {
    try {
      // Langkah 1: Lakukan similarity search
      final results = await SupabaseService.similaritySearch(
        query: question,
        matchThreshold:
            0.6, // Set threshold lebih rendah untuk mendapatkan lebih banyak kandidat
        matchCount: 3,
        embeddings: embeddings,
      );

      // Langkah 2: Cek apakah ada hasil yang relevan
      if (results.isNotEmpty) {
        // Ambil hasil dengan similarity tertinggi
        final topResult = results.first;
        final double similarity = topResult['similarity'] ?? 0.0;

        // Jika similarity di atas threshold, gunakan jawaban dari database
        if (similarity >= RELEVANCE_THRESHOLD) {
          return _formatAnswer(topResult['content'], question, similarity);
        }
      }

      // Langkah 3: Jika tidak ada hasil relevan, gunakan LLM
      return _getLLMResponse(question, results);
    } catch (e) {
      debugPrint('Error in getAnswer: $e');
      // Langkah 4: Fallback untuk error handling
      return _getLLMResponse(question, []);
    }
  }

  /// Format jawaban dari database dengan konteks
  static String _formatAnswer(
    String content,
    String question,
    double similarity,
  ) {
    final confidencePercentage = (similarity * 100).toStringAsFixed(1);

    return '''
Berdasarkan informasi yang tersedia (keyakinan: $confidencePercentage%):

$content
''';
  }

  /// Dapatkan jawaban dari LLM ketika tidak ditemukan hasil yang relevan di database
  static Future<String> _getLLMResponse(
    String question,
    List<Map<String, dynamic>> partialResults,
  ) async {
    try {
      // Buat prompt dengan konteks yang mungkin berguna (meski tidak cukup relevan)
      String prompt = _buildPromptForLLM(question, partialResults);

      // Panggil LLM menggunakan GeminiService
      final geminiService = GeminiService();
      // Pastikan gemini sudah diinisialisasi
      if (!geminiService.isInitialized) {
        // Ambil API key dari service atau environment
        await geminiService.initialize(
          apiKey: '',
        ); // API key akan diambil dari ApiKeyService
      }

      final response = await geminiService.generateResponse(prompt);

      return response;
    } catch (e) {
      debugPrint('Error in _getLLMResponse: $e');
      return "Maaf, saya tidak dapat menemukan informasi yang relevan dan terjadi error saat menghubungi model bahasa. Silakan coba lagi nanti.";
    }
  }

  /// Buat prompt untuk LLM dengan konteks dari hasil partial jika ada
  static String _buildPromptForLLM(
    String question,
    List<Map<String, dynamic>> partialResults,
  ) {
    StringBuffer contextBuilder = StringBuffer();

    // Tambahkan konteks dari hasil partial jika ada
    if (partialResults.isNotEmpty) {
      contextBuilder.writeln(
        "Berikut beberapa informasi yang mungkin relevan, tetapi tidak sepenuhnya menjawab pertanyaan:",
      );

      for (var i = 0; i < partialResults.length; i++) {
        final result = partialResults[i];
        final similarity = result['similarity'] ?? 0.0;
        final simPercent = (similarity * 100).toStringAsFixed(1);

        contextBuilder.writeln(
          "Informasi #${i + 1} (relevansi: $simPercent%):",
        );
        contextBuilder.writeln("${result['content']}");
        contextBuilder.writeln("");
      }
    }

    return '''
Kamu adalah asisten AI yang membantu user di aplikasi Lunaria.
${contextBuilder.toString()}

Pertanyaan user: $question

Berikan jawaban yang informatif dan akurat. Jika kamu tidak memiliki informasi yang cukup atau tidak yakin, akui saja dan jangan memberikan jawaban yang salah. Jawaban diformat dengan Markdown dan singkat namun informatif.
''';
  }
}
