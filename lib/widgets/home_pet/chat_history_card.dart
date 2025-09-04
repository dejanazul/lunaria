import 'package:flutter/material.dart';
import 'package:lunaria/models/chat_message.dart';
import 'package:lunaria/providers/chat_history_provider.dart';
import 'package:lunaria/screens/home_pet/chat_room.dart';
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
              child: Column(
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChatRoom()),
                      );
                    },
                    child: Text("Berbincang dengan luna"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
