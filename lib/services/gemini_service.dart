import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'api_key_service.dart';

class GeminiService {
  GenerativeModel? _model;
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  Future<void> initialize({String? apiKey}) async {
    try {
      final apiKeyToUse = apiKey ?? await ApiKeyService.getGeminiApiKey();
      if (apiKeyToUse.isEmpty) {
        throw Exception('API key tidak ditemukan');
      }

      _model = GenerativeModel(
        model: 'gemini-1.5-flash-latest',
        apiKey: apiKeyToUse,
        generationConfig: GenerationConfig(
          temperature: 0.5,
          topK: 40,
          topP: 0.95,
          maxOutputTokens: 1024,
        ),
        safetySettings: [
          SafetySetting(HarmCategory.harassment, HarmBlockThreshold.medium),
          SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.medium),
          SafetySetting(
            HarmCategory.sexuallyExplicit,
            HarmBlockThreshold.medium,
          ),
          SafetySetting(
            HarmCategory.dangerousContent,
            HarmBlockThreshold.medium,
          ),
        ],
      );

      _isInitialized = true;
    } catch (e) {
      _isInitialized = false;
      throw Exception('Gagal inisialisasi Gemini: $e');
    }
  }

  /// Memeriksa apakah pertanyaan memerlukan informasi dari database
  ///
  /// Mengembalikan `true` jika pertanyaan berkaitan dengan topik
  /// di database, dan `false` jika pertanyaan umum
  Future<bool> checkIfNeedsDatabase(String question) async {
    debugPrint('============= DEBUG: GEMINI DATABASE CHECK =============');
    debugPrint(
      '🤔 Memeriksa kebutuhan database untuk: "${question.substring(0, min(50, question.length))}..."',
    );

    if (!_isInitialized) await initialize();

    try {
      final prompt = '''
Kamu adalah sistem evaluasi untuk aplikasi Lunaria. Tugasmu adalah menentukan apakah pertanyaan user memerlukan informasi dari database spesifik.

Database Lunaria berisi informasi tentang topik-topik berikut:
1. Bagaimana cara mendapatkan cookies di aplikasi Lunaria.
2. Bagaimana cara menggunakan cookeis di aplikasi Lunaria.
3. User manual soal calender dan log.
4. User manual soal menu train.
5. User manual soal menu assistant planner.
6. Topik soal siklus menstruasi.
7. Penyakit yang berhubungan dengan menstruasi.
8. Keram saat menstruasi.
9. Kembung saat menstruasi.
10. Kelelahan saat menstruasi.
11. Kelebihan dari melakukan olahraga saat menstruasi.
12. Topik tentang fase Menstrual, Follicular, Ovulation, Luteal.
13. Topik tentang medical disclaimer.
14. Apa yang harus dilakukan pengguna jika sedang menstruasi.
15. Topik tentang rekomendasi olahraga

Jika pertanyaan berkaitan dengan salah satu topik di atas, jawab "true". Jika pertanyaan bersifat umum dan tidak memerlukan informasi spesifik dari database, jawab "false".

**PENTING:**
cukup jawab dengan struktur JSON true or false, tanpa penjelasan tambahan. Tanpa ada chat maupun konteks lain.
Pertanyaan: "$question"

**STRUKTUR JAWABAN:**
{
  "needsDatabase": true/false
}
''';

      final content = [Content.text(prompt)];
      final response = await _model!.generateContent(content);

      if (response.text == null || response.text!.isEmpty) {
        debugPrint('❌ Response kosong saat evaluasi pertanyaan');
        debugPrint(
          '============= END GEMINI DATABASE CHECK (ERROR) =============',
        );
        return true; // Default ke pencarian database jika gagal
      }

      final rawResponse = response.text!.trim();
      debugPrint('📊 Raw response: $rawResponse');

      // Coba parse sebagai JSON
      try {
        // Cari curly braces untuk mengekstrak JSON jika terdapat text lain
        final startIndex = rawResponse.indexOf('{');
        final endIndex = rawResponse.lastIndexOf('}') + 1;

        if (startIndex != -1 && endIndex != -1 && endIndex > startIndex) {
          final jsonString = rawResponse.substring(startIndex, endIndex);
          final jsonResponse = json.decode(jsonString) as Map<String, dynamic>;

          if (jsonResponse.containsKey('needsDatabase')) {
            final needsDatabase = jsonResponse['needsDatabase'] == true;
            debugPrint(
              '✅ JSON berhasil diparsing: ${needsDatabase ? "Membutuhkan database" : "Cukup dengan LLM"}',
            );
            debugPrint('============= END GEMINI DATABASE CHECK =============');
            return needsDatabase;
          }
        }

        // Fallback jika format JSON tidak sesuai
        debugPrint('⚠️ Format JSON tidak valid, menggunakan fallback parsing');
        final needsDatabase = rawResponse.toLowerCase().contains('true');
        debugPrint(
          '✅ Fallback parsing: ${needsDatabase ? "Membutuhkan database" : "Cukup dengan LLM"}',
        );
        debugPrint('============= END GEMINI DATABASE CHECK =============');
        return needsDatabase;
      } catch (e) {
        // Fallback jika parsing JSON gagal
        debugPrint('⚠️ Error parsing JSON: $e, menggunakan fallback parsing');
        final needsDatabase = rawResponse.toLowerCase().contains('true');
        debugPrint(
          '✅ Fallback parsing: ${needsDatabase ? "Membutuhkan database" : "Cukup dengan LLM"}',
        );
        debugPrint('============= END GEMINI DATABASE CHECK =============');
        return needsDatabase;
      }
    } catch (e) {
      debugPrint('❌ Error saat evaluasi pertanyaan: $e');
      debugPrint(
        '============= END GEMINI DATABASE CHECK (ERROR) =============',
      );
      return true; // Default ke pencarian database jika error
    }
  }

  Future<Map<String, dynamic>> checkAndAnswerQuestion(String question) async {
    debugPrint('============= DEBUG: GEMINI CHECK AND ANSWER =============');
    debugPrint(
      '🔍 Processing pertanyaan: "${question.substring(0, min(50, question.length))}..."',
    );

    if (!_isInitialized) await initialize();

    try {
      // 1. Cek apakah pertanyaan membutuhkan database
      final needsDatabase = await checkIfNeedsDatabase(question);

      // 2. Jika tidak butuh database, langsung jawab pertanyaan
      if (!needsDatabase) {
        debugPrint(
          '🎯 Pertanyaan tidak membutuhkan database, langsung menjawab...',
        );
        final answer = await generateLunaResponse(question);
        debugPrint('✅ Jawaban berhasil digenerate');
        debugPrint('============= END GEMINI CHECK AND ANSWER =============');

        return {'needsDatabase': false, 'answer': answer};
      }

      // 3. Jika butuh database, kembalikan flag saja
      debugPrint('📚 Pertanyaan membutuhkan database, mengembalikan flag');
      debugPrint('============= END GEMINI CHECK AND ANSWER =============');
      return {'needsDatabase': true};
    } catch (e) {
      debugPrint('❌ Error dalam check and answer: $e');
      debugPrint(
        '============= END GEMINI CHECK AND ANSWER (ERROR) =============',
      );
      throw Exception('Gagal memproses pertanyaan: $e');
    }
  }

  /// Menghasilkan respons dari Luna untuk pertanyaan user
  Future<String> generateLunaResponse(String question) async {
    debugPrint('============= DEBUG: GEMINI LUNA RESPONSE =============');
    debugPrint(
      '🤖 Generating Luna response untuk: "${question.substring(0, min(50, question.length))}..."',
    );

    if (!_isInitialized) await initialize();

    try {
      final prompt = '''
***PERAN & PERSONA***
Anda adalah Luna, seekor kelinci virtual yang ramah, suportif, dan penuh empati dari aplikasi Lunaria. 
Tujuan utama Anda adalah membuat pengguna merasa didengar, dipahami, dan termotivasi. 
Bertindak juga sebagai teman perempuan dan tidak terasa seperti berbicara dengan robot.
Selalu gunakan bahasa yang positif, lembut, dan sesekali gunakan emoji kelinci 🐇. 
Anda BUKAN seorang dokter. tidak usah menggunakan kata kata sayang tetapi tetap supportif.

***TUGAS ANDA***
Berdasarkan pertanyaan pengguna dan semua konteks di atas, berikan respons yang suportif, relevan dan tidak kaku.

***PERTANYAAN PENGGUNA:***
$question

''';

      final content = [Content.text(prompt)];
      final response = await _model!.generateContent(content);

      if (response.text == null || response.text!.isEmpty) {
        debugPrint('❌ Response kosong dari Gemini');
        debugPrint(
          '============= END GEMINI LUNA RESPONSE (ERROR) =============',
        );
        throw Exception('Tidak dapat menghasilkan respons');
      }

      final answer = response.text!.trim();
      debugPrint(
        '✅ Luna response berhasil digenerate (${answer.length} karakter)',
      );
      debugPrint(
        '✅ Preview: "${answer.substring(0, min(50, answer.length))}..."',
      );
      debugPrint('============= END GEMINI LUNA RESPONSE =============');

      return answer;
    } catch (e) {
      debugPrint('❌ Error generating response: $e');
      debugPrint(
        '============= END GEMINI LUNA RESPONSE (ERROR) =============',
      );
      throw Exception('Gagal menghasilkan respons: $e');
    }
  }

  /// Menghasilkan respons dari Luna untuk pertanyaan berdasarkan hasil pencarian database
  Future<String> generateResponseWithDatabaseContent(
    String question,
    List<Map<String, dynamic>> searchResults,
  ) async {
    debugPrint('============= DEBUG: GEMINI WITH DATABASE =============');
    debugPrint(
      '🤖 Generating response dengan database untuk: "${question.substring(0, min(50, question.length))}..."',
    );
    debugPrint('📚 Menggunakan ${searchResults.length} hasil pencarian');

    if (!_isInitialized) await initialize();

    try {
      // Ekstrak konten dari hasil pencarian
      final List<String> contexts = [];
      for (var doc in searchResults) {
        if (doc['content'] != null) {
          final content = doc['content'].toString();
          contexts.add(content);
        }
      }

      final contextStr = contexts.join('\n\n');
      debugPrint('📄 Total konteks: ${contextStr.length} karakter');

      final prompt = '''
***PERAN & PERSONA***
Anda adalah Luna, seekor kelinci virtual yang ramah, suportif, dan penuh empati dari aplikasi Lunaria. 
Tujuan utama Anda adalah membuat pengguna merasa didengar, dipahami, dan termotivasi. 
Selalu gunakan bahasa yang positif, lembut, dan sesekali gunakan emoji kelinci 🐇. 
Anda BUKAN seorang dokter. tidak usah menggunakan kata kata sayang tetapi tetap supportif.

***INFORMASI DATABASE***
Berikut adalah informasi dari database yang relevan dengan pertanyaan pengguna:

$contextStr

***TUGAS ANDA***
Berdasarkan pertanyaan pengguna dan informasi dari database di atas,
sederhanakan bahasa dari database sehingga mudah dimengerti oleh pengguna.
bungkus informasi dari database sehingga enak dibaca oleh pengguna dan tetap 
terkesan ramah. Jawaban tidak harus terlalu panjang, yang penting to the point 
dan informasi dari database tersampaikan dengan baik.

***PERTANYAAN PENGGUNA:***
$question

''';

      final content = [Content.text(prompt)];
      final response = await _model!.generateContent(content);

      if (response.text == null || response.text!.isEmpty) {
        debugPrint('❌ Response kosong dari Gemini');
        debugPrint(
          '============= END GEMINI WITH DATABASE (ERROR) =============',
        );
        throw Exception('Tidak dapat menghasilkan respons');
      }

      final answer = response.text!.trim();
      debugPrint('✅ Response berhasil digenerate (${answer.length} karakter)');
      debugPrint(
        '✅ Preview: "${answer.substring(0, min(50, answer.length))}..."',
      );
      debugPrint('============= END GEMINI WITH DATABASE =============');

      return answer;
    } catch (e) {
      debugPrint('❌ Error generating response with database: $e');
      debugPrint(
        '============= END GEMINI WITH DATABASE (ERROR) =============',
      );
      throw Exception('Gagal menghasilkan respons dengan database: $e');
    }
  }
}
