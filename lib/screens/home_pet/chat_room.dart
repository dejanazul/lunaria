import 'package:flutter/material.dart';
import 'package:lunaria/constants/app_colors.dart';
import 'package:lunaria/helpers/responsive_helper.dart';
import 'package:lunaria/providers/chat_history_provider.dart';
import 'package:lunaria/widgets/chat/chat_error_message.dart';
import 'package:lunaria/widgets/chat/chat_input_field.dart';
import 'package:lunaria/widgets/chat/chat_message_list.dart';
import 'package:lunaria/widgets/chat/chat_typing_indicator.dart';
import 'package:provider/provider.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({super.key});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Menambahkan post-frame callback untuk melakukan scroll ke bawah saat pertama kali dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    // Mendengarkan perubahan pada ChatHistoryProvider
    Future.microtask(() {
      final chatProvider = Provider.of<ChatHistoryProvider>(
        context,
        listen: false,
      );
      chatProvider.addListener(_onChatProviderChanged);
    });
  }

  void _onChatProviderChanged() {
    // Scroll ke bawah saat ada perubahan pada chat history
    _scrollToBottom();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    // Hapus listener saat widget di-dispose
    final chatProvider = Provider.of<ChatHistoryProvider>(
      context,
      listen: false,
    );
    chatProvider.removeListener(_onChatProviderChanged);

    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final chatProvider = Provider.of<ChatHistoryProvider>(
      context,
      listen: false,
    );

    // Simpan pesan user
    final userMessage = _messageController.text.trim();
    _messageController.clear();

    // Kirim pesan ke ChatHistoryProvider yang akan menangani integrasi dengan Gemini
    chatProvider.sendMessageToGemini(userMessage).catchError((error) {
      // Error sudah ditangani di dalam ChatHistoryProvider
      // Di sini kita bisa menambahkan handling tambahan jika diperlukan
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${error.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    });

    // Scroll ke bawah setelah mengirim pesan
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chat dengan Luna',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: ResponsiveHelper.getSubheadingFontSize(context),
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: Colors.white, // Background putih sesuai Figma
        child: Column(
          children: [
            // Chat messages area
            Expanded(
              child: Consumer<ChatHistoryProvider>(
                builder: (context, chatProvider, child) {
                  return Stack(
                    children: [
                      // List chat messages
                      ChatMessageList(scrollController: _scrollController),

                      // Indikator Loading
                      if (chatProvider.chatState == ChatState.loading)
                        Positioned(
                          bottom: ResponsiveHelper.getMediumSpacing(context),
                          left: ResponsiveHelper.getMediumSpacing(context),
                          child: const ChatTypingIndicator(),
                        ),

                      // Error message
                      if (chatProvider.chatState == ChatState.error &&
                          chatProvider.errorMessage != null)
                        Positioned(
                          bottom: ResponsiveHelper.getMediumSpacing(context),
                          left: 0,
                          right: 0,
                          child: ChatErrorMessage(
                            errorMessage: chatProvider.errorMessage!,
                            onDismiss: () => chatProvider.clearError(),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),

            // Message input area
            ChatInputField(
              controller: _messageController,
              onSend: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}
