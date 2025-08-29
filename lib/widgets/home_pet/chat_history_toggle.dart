import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lunaria/providers/chat_history_provider.dart';

class ChatHistoryToggle extends StatelessWidget {
  const ChatHistoryToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatHistoryProvider>(
      builder: (context, chatProvider, child) {
        return GestureDetector(
          onTap: () {
            chatProvider.toggleHistoryVisibility();
          },
          child: Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              color: const Color(0xFFE9CBEE),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF913F9E), width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Icon(
              Icons.history,
              color: Color(0xFF913F9E),
              size: 28,
            ),
          ),
        );
      },
    );
  }
}
