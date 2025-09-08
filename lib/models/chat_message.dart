class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final bool
  isFromDatabase; // Menandakan apakah respons dari database atau hanya LLM

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.isFromDatabase = false,
  });
}
