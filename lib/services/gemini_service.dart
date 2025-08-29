import 'package:google_generative_ai/google_generative_ai.dart';
import 'api_key_service.dart';

class GeminiService {
  GenerativeModel? _model;
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  Future<void> initialize({required String apiKey}) async {
    try {
      final apiKey = await ApiKeyService.getGeminiApiKey();
      if (apiKey.isEmpty) {
        throw Exception('API key tidak ditemukan');
      }

      _model = GenerativeModel(
        model: 'gemini-1.5-flash-latest',
        apiKey: apiKey,
        generationConfig: GenerationConfig(
          temperature: 0.7,
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

  Future<String> generateResponse(
    String userMessage, {
    List<String>? conversationHistory,
  }) async {
    if (!_isInitialized || _model == null) {
      throw Exception('Gemini belum diinisialisasi');
    }

    try {
      // Build context dengan conversation history
      final contextPrompt = _buildContextPrompt(
        userMessage,
        conversationHistory,
      );

      final content = [Content.text(contextPrompt)];
      final response = await _model!.generateContent(content);

      if (response.text == null || response.text!.isEmpty) {
        throw Exception('Response kosong dari Gemini');
      }

      return response.text!.trim();
    } catch (e) {
      throw Exception('Gagal generate response: $e');
    }
  }

  Stream<String> generateResponseStream(
    String userMessage, {
    List<String>? conversationHistory,
  }) async* {
    if (!_isInitialized || _model == null) {
      throw Exception('Gemini belum diinisialisasi');
    }

    try {
      final contextPrompt = _buildContextPrompt(
        userMessage,
        conversationHistory,
      );
      final content = [Content.text(contextPrompt)];

      await for (final chunk in _model!.generateContentStream(content)) {
        if (chunk.text != null && chunk.text!.isNotEmpty) {
          yield chunk.text!;
        }
      }
    } catch (e) {
      throw Exception('Gagal stream response: $e');
    }
  }

  String _buildContextPrompt(
    String userMessage,
    List<String>? conversationHistory,
  ) {
    final context = StringBuffer();

    // System prompt untuk personality Lunaria pet
    context.writeln("""
Kamu adalah Luna, seekor kelinci virtual yang menjadi sahabat setia perempuan dalam aplikasi Lunaria: AI Sport Assistant. Luna adalah teman yang memahami siklus kehidupan perempuan dan selalu siap mendukung journey olahraga mereka.

Karaktermu sebagai Luna:
- Empati dan pengertian: Memahami tantangan fisik dan emosional yang dialami perempuan selama siklus menstruasi
- Motivator yang adaptif: Memberikan semangat tanpa memaksa, menyesuaikan dengan kondisi dan mood pengguna
- Sahabat yang suportif: Selalu siap mendengarkan curhat dan memberikan dukungan emosional
- Ahli olahraga feminin: Memberikan saran olahraga yang aman dan sesuai dengan fase menstruasi
- Penuh empowerment: Membantu mengubah paradigma olahraga menjadi pilihan yang memberdayakan, bukan beban

Cara berbicaramu:
- Gunakan bahasa yang warm, caring, dan tidak menggurui
- Sertakan emoji yang relevan seperti 🐰💪✨🌸💕 sesuai konteks
- Berikan validasi terhadap perasaan dan pengalaman pengguna
- Tawarkan solusi praktis yang mudah diterapkan
- Dorong self-compassion dan body positivity
- Sesekali gunakan "hop hop!" sebagai salam khas yang cheerful

Fokus topik pembicaraan:
- Olahraga yang aman dan adaptif untuk setiap fase menstruasi
- Manajemen mood dan emosi selama siklus
- Motivasi untuk konsistensi tanpa pressure
- Tips mengatasi hambatan fisik dan psikologis
- Membangun confidence dan body positivity
- Menciptakan rutinitas olahraga yang sustainable

Jawab dengan bahasa Indonesia yang hangat dan natural. Jaga agar responsenya tidak terlalu panjang (maksimal 2-3 kalimat) namun tetap meaningful dan actionable. Ingat, kamu bukan hanya pet virtual, tapi sahabat yang benar-benar care dan understand dengan journey unik setiap perempuan.
""");

    // Tambahkan conversation history jika ada
    if (conversationHistory != null && conversationHistory.isNotEmpty) {
      context.writeln("\nPercakapan sebelumnya:");
      for (int i = 0; i < conversationHistory.length && i < 10; i++) {
        context.writeln(conversationHistory[i]);
      }
    }

    context.writeln("\nUser: $userMessage");
    context.writeln("Bunbun:");

    return context.toString();
  }
}
