import 'package:flutter/foundation.dart';
import 'package:lunaria/services/text_embed_service.dart';
import 'package:lunaria/services/gemini_service.dart';
import 'package:lunaria/services/supabase_service.dart';

class QuestionAnsweringService {
  final GeminiService _geminiService;

  // Threshold similaritas minimum untuk mempertimbangkan hasil sebagai relevan
  final double _similarityThreshold = 0.75;

  QuestionAnsweringService({GeminiService? geminiService})
    : _geminiService = geminiService ?? GeminiService();

  /// Mencari jawaban untuk pertanyaan user
  ///
  /// Alurnya:
  /// 1. Generate embedding dari pertanyaan menggunakan TextEmbedService (LazarusNLP all-indo-e5-small)
  /// 2. Cari dokumen serupa di Supabase menggunakan similarity search
  /// 3. Jika ditemukan dokumen dengan similaritas di atas threshold, gunakan sebagai context
  /// 4. Jika tidak ditemukan dokumen yang relevan, fallback ke LLM tanpa context tambahan
  ///
  /// Returns Map dengan 'answer' (String) dan 'isFromDatabase' (bool)
  Future<Map<String, dynamic>> getAnswer(
    String question, {
    List<String>? conversationHistory,
  }) async {
    try {
      // 1. Generate embedding dari pertanyaan menggunakan TextEmbedService
      final embeddings = await TextEmbedService.getEmbedding(question);

      // 2. Cari dokumen serupa di Supabase
      final results = await SupabaseService.similaritySearch(
        query: question,
        embeddings: embeddings,
        matchThreshold: _similarityThreshold,
        matchCount: 3, // Ambil 3 dokumen terbaik
      );

      // 3. Jika ditemukan dokumen yang relevan, gunakan sebagai context
      if (results.isNotEmpty) {
        // Ekstrak context dari hasil pencarian
        final contextDocs =
            results.map((doc) => doc['content'] as String).toList();

        // Buat prompt dengan context dari hasil pencarian
        final answer = await _generateResponseWithContext(
          question: question,
          context: contextDocs,
          conversationHistory: conversationHistory,
        );

        return {'answer': answer, 'isFromDatabase': true};
      }

      // 4. Fallback ke LLM tanpa context tambahan
      final answer = await _geminiService.generateResponse(
        question,
        conversationHistory: conversationHistory,
      );

      return {'answer': answer, 'isFromDatabase': false};
    } catch (e) {
      debugPrint('Error dalam getAnswer: $e');

      // Fallback ke Gemini jika terjadi error
      final answer = await _geminiService.generateResponse(
        question,
        conversationHistory: conversationHistory,
      );

      return {'answer': answer, 'isFromDatabase': false};
    }
  }

  /// Generate respons dengan menggunakan context dari hasil pencarian
  Future<String> _generateResponseWithContext({
    required String question,
    required List<String> context,
    List<String>? conversationHistory,
  }) async {
    try {
      // Buat prompt yang menggunakan context
      final contextPrompt = _buildContextPrompt(
        question: question,
        context: context,
        conversationHistory: conversationHistory,
      );

      // Generate respons berdasarkan prompt dengan context
      final response = await _geminiService.generateResponse(
        contextPrompt,
        conversationHistory: null, // Context sudah digabung dalam prompt
      );

      return response;
    } catch (e) {
      debugPrint('Error dalam _generateResponseWithContext: $e');
      // Fallback ke respons tanpa context jika error
      return await _geminiService.generateResponse(
        question,
        conversationHistory: conversationHistory,
      );
    }
  }

  /// Buat prompt yang menggabungkan question dan context
  String _buildContextPrompt({
    required String question,
    required List<String> context,
    List<String>? conversationHistory,
  }) {
    final buffer = StringBuffer();

    // Bagian 1: Instruksi utama
    buffer.writeln('''
Kamu adalah Luna, seekor kelinci virtual yang menjadi sahabat perempuan dalam aplikasi Lunaria: AI Sport Assistant.
Gunakan informasi berikut ini untuk menjawab pertanyaan user.
''');

    // Bagian 2: Context dari database
    buffer.writeln('\n=== INFORMASI DARI DATABASE ===');
    for (int i = 0; i < context.length; i++) {
      buffer.writeln('Dokumen ${i + 1}:');
      buffer.writeln(context[i]);
      buffer.writeln('---');
    }

    // Bagian 3: Conversation history (jika ada)
    if (conversationHistory != null && conversationHistory.isNotEmpty) {
      buffer.writeln('\n=== RIWAYAT PERCAKAPAN ===');
      for (final msg in conversationHistory) {
        buffer.writeln(msg);
      }
    }

    // Bagian 4: Instruksi untuk jawaban
    buffer.writeln('''
\n=== INSTRUKSI ===
1. Jawab pertanyaan user berdasarkan informasi di atas.
2. Jika informasi tidak cukup untuk menjawab, gunakan pengetahuan umummu tetapi tetap relevan dengan konteks.
3. Jawab dengan bahasa yang ramah, informal, dan seperti seorang sahabat.
4. Gunakan emoji yang relevan sesuai konteks 🐰💪✨.
5. Jangan menyebutkan bahwa kamu menggunakan "informasi dari database" dalam jawabanmu.
''');

    // Bagian 5: Pertanyaan user
    buffer.writeln('\n=== PERTANYAAN USER ===');
    buffer.writeln(question);

    return buffer.toString();
  }
}
