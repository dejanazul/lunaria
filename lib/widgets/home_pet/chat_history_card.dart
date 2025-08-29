import 'package:flutter/material.dart';
import 'package:lunaria/models/chat_message.dart';
import 'package:lunaria/providers/chat_history_provider.dart';
import 'package:provider/provider.dart';

class ChatHistoryCard extends StatefulWidget {
  final TextEditingController chatController;
  final Future<void> Function() sendMessage; // Pastikan async agar bisa await

  const ChatHistoryCard({
    super.key,
    required this.chatController,
    required this.sendMessage,
  });

  @override
  State<ChatHistoryCard> createState() => _ChatHistoryCardState();
}

class _ChatHistoryCardState extends State<ChatHistoryCard> {
  final _scrollController = ScrollController();

  void _autoScrollToBottom() {
    if (!_scrollController.hasClients) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatHistoryProvider>(
      builder: (context, chatProvider, child) {
        // Auto-scroll setiap kali daftar pesan berubah & card terlihat
        if (chatProvider.isHistoryVisible) _autoScrollToBottom();

        return AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          bottom: chatProvider.isHistoryVisible ? 0 : -350,
          left: 0,
          right: 0,
          height: 400,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: 16 + MediaQuery.of(context).padding.bottom,
            ),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white, // Warna solid putih, tidak transparan
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child:
                  chatProvider.isHistoryVisible
                      ? _buildChatHistoryContent(context, chatProvider)
                      : const SizedBox.shrink(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildChatHistoryContent(
    BuildContext context,
    ChatHistoryProvider chatProvider,
  ) {
    final isDisabled = chatProvider.isLoading || chatProvider.needsApiKey;
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
          child: const SizedBox(height: 10),
        ),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            reverse: true,
            itemCount: chatProvider.chatHistory.length,
            itemBuilder: (context, index) {
              final message = chatProvider.chatHistory[index];
              return _buildChatMessage(message);
            },
          ),
        ),
        // Input
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: const BoxDecoration(
            color: Color(0xFFF5F5F5),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: widget.chatController,
                  enabled: !isDisabled,
                  decoration: InputDecoration(
                    hintText:
                        chatProvider.isLoading
                            ? "Luna is typing..."
                            : "Type a message...",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                  onSubmitted: (_) async {
                    if (!isDisabled) await widget.sendMessage();
                  },
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: isDisabled ? null : () async => widget.sendMessage(),
                borderRadius: BorderRadius.circular(25),
                child: Opacity(
                  opacity: isDisabled ? 0.5 : 1,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Color(0xFF913F9E),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChatMessage(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser)
            Container(
              width: 28,
              height: 28,
              margin: const EdgeInsets.only(right: 8, top: 2),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage('assets/images/pet_main_image.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color:
                    message.isUser
                        ? const Color(0xFFD8E8FF)
                        : const Color(0xFFE9E9EB),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color:
                      message.isUser
                          ? const Color(0xFF64B5F6)
                          : const Color(0xFFCCCCCC),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.isUser ? 'You' : 'Luna',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color:
                          message.isUser
                              ? const Color(0xFF64B5F6)
                              : const Color(0xFF913F9E),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(message.text, style: const TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ),
          if (message.isUser)
            Container(
              width: 28,
              height: 28,
              margin: const EdgeInsets.only(left: 8, top: 2),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF64B5F6),
              ),
              child: const Icon(Icons.person, color: Colors.white, size: 18),
            ),
        ],
      ),
    );
  }
}
