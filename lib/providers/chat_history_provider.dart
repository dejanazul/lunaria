import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../services/gemini_service.dart';
import '../services/api_key_service.dart';

enum ChatState { idle, loading, error, needsApiKey }

class ChatHistoryProvider extends ChangeNotifier {
  final List<ChatMessage> _chatHistory = [];
  bool _isHistoryVisible = false;
  final GeminiService _geminiService = GeminiService();
  ChatState _chatState = ChatState.idle;
  String? _errorMessage;

  // Getters
  List<ChatMessage> get chatHistory => List.unmodifiable(_chatHistory);
  bool get isHistoryVisible => _isHistoryVisible;
  ChatState get chatState => _chatState;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _chatState == ChatState.loading;
  bool get needsApiKey =>
      _chatState == ChatState.needsApiKey; // Tetap biarkan getter ini

  // Initialize service
  Future<void> initializeGemini() async {
    try {
      _chatState = ChatState.loading;
      notifyListeners();

      // Hapus pengecekan API key, karena kita akan selalu menggunakan hardcoded API key
      // Dapatkan API key langsung dari service
      final apiKey =
          await ApiKeyService.getGeminiApiKey(); // Ini akan mengembalikan default API key

      await _geminiService.initialize(
        apiKey: apiKey,
      ); // Pastikan GeminiService menerima apiKey sebagai parameter
      _chatState = ChatState.idle;
      _errorMessage = null;

      // Add welcome message jika chat history kosong
      if (_chatHistory.isEmpty) {
        _addWelcomeMessage();
      }

      notifyListeners();
    } catch (e) {
      _chatState = ChatState.error;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  void _addWelcomeMessage() {
    final welcomeMessage = ChatMessage(
      text: "Hop hop! 🐰 Hai, aku Luna! Ada yang bisa aku bantu hari ini?",
      isUser: false,
      timestamp: DateTime.now(),
    );
    _chatHistory.insert(0, welcomeMessage);
  }

  void toggleHistoryVisibility() {
    _isHistoryVisible = !_isHistoryVisible;

    if (!_isHistoryVisible) {
      // Clear chat history ketika card disembunyikan
      _chatHistory.clear();
    } else if (_isHistoryVisible && _chatHistory.isEmpty) {
      // Initialize Gemini dan add welcome message ketika dibuka
      initializeGemini();
    }

    notifyListeners();
  }

  void addMessage(ChatMessage message) {
    _chatHistory.insert(0, message);
    notifyListeners();
  }

  Future<void> sendMessageToGemini(String userMessage) async {
    if (userMessage.trim().isEmpty) return;

    try {
      // Add user message
      final userMsg = ChatMessage(
        text: userMessage.trim(),
        isUser: true,
        timestamp: DateTime.now(),
      );
      addMessage(userMsg);

      // Set loading state
      _chatState = ChatState.loading;
      notifyListeners();

      // Prepare conversation history
      final conversationHistory = _buildConversationHistory();

      // Get AI response
      final aiResponse = await _geminiService.generateResponse(
        userMessage,
        conversationHistory: conversationHistory,
      );

      // Add AI response
      final aiMessage = ChatMessage(
        text: aiResponse,
        isUser: false,
        timestamp: DateTime.now(),
      );
      addMessage(aiMessage);

      _chatState = ChatState.idle;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _chatState = ChatState.error;
      _errorMessage = e.toString();

      // Add error message to chat
      final errorMessage = ChatMessage(
        text: "Maaf, terjadi kesalahan: ${e.toString()} 😅",
        isUser: false,
        timestamp: DateTime.now(),
      );
      addMessage(errorMessage);

      notifyListeners();
    }
  }

  List<String> _buildConversationHistory() {
    // Ambil 5 pesan terakhir untuk context
    final recentMessages = _chatHistory.take(5).toList().reversed.toList();
    final history = <String>[];

    for (final message in recentMessages) {
      if (message.isUser) {
        history.add("User: ${message.text}");
      } else {
        history.add("Bunbun: ${message.text}");
      }
    }

    return history;
  }

  Future<void> setupApiKey(String apiKey) async {
    try {
      await ApiKeyService.saveGeminiApiKey(apiKey);
      await initializeGemini();
    } catch (e) {
      _chatState = ChatState.error;
      _errorMessage = "Gagal menyimpan API key: $e";
      notifyListeners();
    }
  }

  void clearChat() {
    _chatHistory.clear();
    _addWelcomeMessage();
    notifyListeners();
  }

  void clearError() {
    _chatState = ChatState.idle;
    _errorMessage = null;
    notifyListeners();
  }
}
