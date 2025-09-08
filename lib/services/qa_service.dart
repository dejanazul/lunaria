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
        return {
          'answer': checkResult['answer'],
          'source': 'ai',
          'used_database': false,
        };
      }

      // 3. Jika butuh database, lakukan text embedding
      debugPrint(
        '📚 Pertanyaan membutuhkan database, melakukan text embedding...',
      );
      final embeddings = await TextEmbedService.getEmbedding(question);
      debugPrint('HASIL EMBEDDING: $embeddings');

      if (embeddings.isEmpty) {
        debugPrint('⚠️ Gagal membuat embedding, menggunakan fallback response');
        final fallbackAnswer = await _geminiService.generateLunaResponse(
          "Maaf, saya tidak dapat memproses embedding untuk pertanyaan Anda. " +
              "Silakan coba lagi atau ajukan pertanyaan dengan cara yang berbeda.",
        );

        return {
          'answer': fallbackAnswer,
          'source': 'ai',
          'used_database': false,
          'error': 'embedding_failed',
        };
      }

      // 4. Embedding berhasil dibuat, untuk saat ini kita hanya mengembalikan info ini
      debugPrint(
        '✅ Embedding berhasil dibuat dengan ${embeddings.length} dimensi',
      );
      debugPrint('✅ Mengembalikan respons sementara tentang embedding');
      debugPrint('============= END QA SERVICE =============');

      final tempAnswer = await _geminiService.generateLunaResponse(
        "Saya telah mengidentifikasi bahwa pertanyaan Anda membutuhkan data dari database. " +
            "Text embedding telah berhasil dibuat dengan ${embeddings.length} dimensi. " +
            "Saya sedang mencari informasi yang relevan untuk menjawab pertanyaan Anda.",
      );

      return {
        'answer': tempAnswer,
        'source': 'processing',
        'used_database': true,
        'embedding_length': embeddings.length,
      };
    } catch (e) {
      debugPrint('❌ Error in QA service: $e');
      debugPrint('============= END QA SERVICE (ERROR) =============');
      throw Exception('Gagal memproses pertanyaan: $e');
    }
  }

  /// Membangun context dari hasil search Supabase (untuk implementasi RAG nanti)
  String _buildContextFromResults(List<Map<String, dynamic>> results) {
    // Existing implementation...
    if (results.isEmpty) return '';

    final buffer = StringBuffer();
    buffer.writeln('Berikut adalah informasi dari database yang relevan:');
    buffer.writeln();

    for (int i = 0; i < results.length; i++) {
      final doc = results[i];
      final title = doc['title'] ?? 'Dokumen ${i + 1}';
      final content = doc['content'] ?? '';
      final similarity = doc['similarity']?.toStringAsFixed(2) ?? 'N/A';

      buffer.writeln('---');
      buffer.writeln('DOKUMEN: $title (Relevansi: $similarity)');
      buffer.writeln('ISI: $content');
      buffer.writeln('---');
      buffer.writeln();
    }

    return buffer.toString();
  }
}
