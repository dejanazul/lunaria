import 'package:flutter/material.dart';
import 'package:lunaria/constants/app_colors.dart';
import 'package:lunaria/helpers/responsive_helper.dart';
import 'package:lunaria/providers/chat_history_provider.dart';
import 'package:lunaria/widgets/home_pet/message_bubble.dart';
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
                      Container(
                        color: Colors.white, // Background putih sesuai Figma
                        padding: ResponsiveHelper.getHorizontalPadding(context),
                        child: ListView.builder(
                          controller: _scrollController,
                          reverse: false,
                          padding: EdgeInsets.only(
                            top: ResponsiveHelper.getMediumSpacing(context),
                            bottom:
                                chatProvider.chatState == ChatState.loading
                                    ? ResponsiveHelper.getLargeSpacing(
                                          context,
                                        ) *
                                        2
                                    : ResponsiveHelper.getMediumSpacing(
                                      context,
                                    ),
                          ),
                          itemCount: chatProvider.chatHistory.length,
                          itemBuilder: (context, index) {
                            final message = chatProvider.chatHistory[index];
                            return MessageBubble(message);
                          },
                        ),
                      ),

                      // Indikator Loading
                      if (chatProvider.chatState == ChatState.loading)
                        Positioned(
                          bottom: ResponsiveHelper.getMediumSpacing(context),
                          left: ResponsiveHelper.getMediumSpacing(context),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: ResponsiveHelper.getMediumSpacing(
                                context,
                              ),
                              vertical: ResponsiveHelper.getSmallSpacing(
                                context,
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(
                                ResponsiveHelper.getCardBorderRadius(context),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: ResponsiveHelper.getMediumSpacing(
                                    context,
                                  ),
                                  height: ResponsiveHelper.getMediumSpacing(
                                    context,
                                  ),
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.primary,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: ResponsiveHelper.getSmallSpacing(
                                    context,
                                  ),
                                ),
                                Text(
                                  "Luna sedang mengetik...",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize:
                                        ResponsiveHelper.getCaptionFontSize(
                                          context,
                                        ),
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      // Error message
                      if (chatProvider.chatState == ChatState.error &&
                          chatProvider.errorMessage != null)
                        Positioned(
                          bottom: ResponsiveHelper.getMediumSpacing(context),
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              margin: ResponsiveHelper.getHorizontalPadding(
                                context,
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: ResponsiveHelper.getMediumSpacing(
                                  context,
                                ),
                                vertical: ResponsiveHelper.getSmallSpacing(
                                  context,
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red.shade100,
                                borderRadius: BorderRadius.circular(
                                  ResponsiveHelper.getCardBorderRadius(context),
                                ),
                                border: Border.all(color: Colors.red.shade300),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      "Error: ${chatProvider.errorMessage}",
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize:
                                            ResponsiveHelper.getCaptionFontSize(
                                              context,
                                            ),
                                        color: Colors.red.shade700,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () => chatProvider.clearError(),
                                    child: const Text(
                                      "Tutup",
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 12,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),

            // Message input area
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.getMediumSpacing(context),
                vertical: ResponsiveHelper.getSmallSpacing(context),
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    color: Color(
                      0xFFE9E9EB,
                    ), // Border warna abu-abu sesuai Figma
                    width: 1,
                  ),
                ),
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    // Text input
                    Expanded(
                      child: Consumer<ChatHistoryProvider>(
                        builder: (context, chatProvider, child) {
                          final isLoading =
                              chatProvider.chatState == ChatState.loading;

                          return Container(
                            decoration: BoxDecoration(
                              color:
                                  isLoading
                                      ? const Color(0xFFE9E9EB).withOpacity(0.7)
                                      : const Color(0xFFE9E9EB),
                              borderRadius: BorderRadius.circular(
                                ResponsiveHelper.getCardBorderRadius(context),
                              ),
                            ),
                            child: TextField(
                              controller: _messageController,
                              enabled: !isLoading,
                              decoration: InputDecoration(
                                hintText: 'Ketik pesan...',
                                hintStyle: TextStyle(
                                  color: const Color(0xFF8E8E93),
                                  fontFamily: 'Poppins',
                                  fontSize: ResponsiveHelper.getBodyFontSize(
                                    context,
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: ResponsiveHelper.getMediumSpacing(
                                    context,
                                  ),
                                  vertical: ResponsiveHelper.getSmallSpacing(
                                    context,
                                  ),
                                ),
                                border: InputBorder.none,
                              ),
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: ResponsiveHelper.getBodyFontSize(
                                  context,
                                ),
                                color: Colors.black,
                              ),
                              onSubmitted: (_) => _sendMessage(),
                              minLines: 1,
                              maxLines: 5,
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(width: ResponsiveHelper.getSmallSpacing(context)),
                    // Send button
                    Consumer<ChatHistoryProvider>(
                      builder: (context, chatProvider, child) {
                        final isLoading =
                            chatProvider.chatState == ChatState.loading;

                        return Material(
                          color:
                              isLoading
                                  ? AppColors.primary.withOpacity(0.7)
                                  : AppColors.primary,
                          borderRadius: BorderRadius.circular(
                            ResponsiveHelper.getCardBorderRadius(context),
                          ),
                          child: InkWell(
                            onTap: isLoading ? null : _sendMessage,
                            borderRadius: BorderRadius.circular(
                              ResponsiveHelper.getCardBorderRadius(context),
                            ),
                            child: Container(
                              padding: EdgeInsets.all(
                                ResponsiveHelper.getSmallSpacing(context),
                              ),
                              child: Icon(
                                isLoading
                                    ? Icons.hourglass_bottom_rounded
                                    : Icons.arrow_upward_rounded,
                                color: Colors.white,
                                size:
                                    ResponsiveHelper.getIconSize(context) * 0.8,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
