import 'package:flutter/foundation.dart';
import 'package:lunaria/services/supabase_service.dart';
import 'package:lunaria/services/gemini_service.dart';
import 'package:lunaria/services/text_embed_service.dart';

class QAService {
  final GeminiService _geminiService;
  final SupabaseService _supabaseService;
  final TextEmbedService _textEmbedService;

  QAService({
    GeminiService? geminiService,
    SupabaseService? supabaseService,
    TextEmbedService? textEmbedService,
  }) : _geminiService = geminiService ?? GeminiService(),
       _supabaseService = supabaseService ?? SupabaseService(),
       _textEmbedService = textEmbedService ?? TextEmbedService();

  /// Menghasilkan jawaban untuk pertanyaan user
  Future<Map<String, dynamic>> getAnswer(String question) async {
    debugPrint('============= DEBUG: QA SERVICE =============');
    debugPrint(
      '🔍 Memproses pertanyaan: "${question.substring(0, question.length > 50 ? 50 : question.length)}..."',
    );

    try {
      // 1. Cek dan jawab pertanyaan jika tidak butuh database
      final checkResult = await _geminiService.checkAndAnswerQuestion(question);

      // 2. Jika tidak membutuhkan database, kembalikan jawaban dari LLM
      if (checkResult['needsDatabase'] == false) {
        debugPrint('✅ Mendapatkan jawaban langsung dari LLM');
        debugPrint('============= END QA SERVICE =============');
        return {'answer': checkResult['answer'], 'used_database': false};
      }

      // 3. Jika butuh database, lakukan text embedding
      debugPrint(
        '📚 Pertanyaan membutuhkan database, melakukan text embedding...',
      );
      final embeddings = await _textEmbedService.getEmbedding(question);
      debugPrint('HASIL EMBEDDING: $embeddings');

      if (embeddings.isEmpty) {
        debugPrint('⚠️ Gagal membuat embedding, menggunakan fallback response');
        final fallbackAnswer = await _geminiService.generateLunaResponse(
          "Maaf, saya tidak dapat memproses embedding untuk pertanyaan Anda. " "Silakan coba lagi atau ajukan pertanyaan dengan cara yang berbeda.",
        );

        return {
          'answer': fallbackAnswer,
          'used_database': false,
          'error': 'embedding_failed',
        };
      }

      // 4. Embedding berhasil dibuat, untuk saat ini kita hanya mengembalikan info ini
      debugPrint(
        '✅ Embedding berhasil dibuat dengan ${embeddings.length} dimensi',
      );
      debugPrint('🔍 Melakukan similarity search di Supabase...');
      try {
        final searchResults = await _supabaseService.similaritySearch(
          query: question,
          embeddings: embeddings,
          matchThreshold: 0.7, // Sesuaikan threshold sesuai kebutuhan
          matchCount: 5,
        );
        debugPrint(
          '✅ Similarity search selesai. Ditemukan ${searchResults.length} hasil',
        );

        if (searchResults.isEmpty) {
          // Jika tidak ada hasil yang ditemukan
          debugPrint('⚠️ Tidak ada hasil yang ditemukan di database');
          final noResultAnswer = await _geminiService.generateLunaResponse(
            "Saya telah melakukan research terkait pertanyaan Anda tentang '$question', " "tetapi tidak menemukan informasi yang relevan pada database saya. " +
                "Saya akan mencoba menjawab berdasarkan pengetahuan umum saya.",
          );

          return {
            'answer': noResultAnswer,
            'used_database': true,
            'search_results': 0,
          };
        }

        for (int i = 0; i < searchResults.length && i < 2; i++) {
          final doc = searchResults[i];
          final title = doc['title'] ?? 'Untitled';
          final similarity = doc['similarity']?.toStringAsFixed(4) ?? 'N/A';
          debugPrint('📄 Result #${i + 1}: "$title" (Similarity: $similarity)');
        }

        // Gunakan hasil pencarian untuk menghasilkan jawaban yang ditingkatkan
        debugPrint('🤖 Menghasilkan jawaban berdasarkan hasil database...');
        final databaseAnswer = await _geminiService
            .generateResponseWithDatabaseContent(question, searchResults);

        return {
          'answer': databaseAnswer,
          'source': 'database',
          'used_database': true,
          'search_results': searchResults.length,
          'raw_results': searchResults,
        };
      } catch (e) {
        debugPrint('❌ Error saat similarity search: $e');
        final errorAnswer = await _geminiService.generateLunaResponse(
          "Maaf, saya mengalami kendala teknis saat mencari di database. " "Saya akan mencoba menjawab pertanyaan Anda berdasarkan pengetahuan umum saya.",
        );

        return {
          'answer': errorAnswer,
          'source': 'ai',
          'used_database': true,
          'error': 'search_failed',
          'error_message': e.toString(),
        };
      }
    } catch (e) {
      debugPrint('❌ Error in QA service: $e');
      debugPrint('============= END QA SERVICE (ERROR) =============');
      throw Exception('Gagal memproses pertanyaan: $e');
    }
  }
}
