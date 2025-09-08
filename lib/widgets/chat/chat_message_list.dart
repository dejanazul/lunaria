import 'package:flutter/material.dart';
import 'package:lunaria/helpers/responsive_helper.dart';
import 'package:lunaria/providers/chat_history_provider.dart';
import 'package:lunaria/widgets/home_pet/message_bubble.dart';
import 'package:provider/provider.dart';

class ChatMessageList extends StatefulWidget {
  final ScrollController scrollController;

  const ChatMessageList({super.key, required this.scrollController});

  @override
  State<ChatMessageList> createState() => _ChatMessageListState();
}

class _ChatMessageListState extends State<ChatMessageList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ChatHistoryProvider>(
      builder: (context, chatProvider, child) {
        return Container(
          color: Colors.white,
          padding: ResponsiveHelper.getHorizontalPadding(context),
          child: ListView.builder(
            controller: widget.scrollController,
            reverse: false,
            padding: EdgeInsets.only(
              top: ResponsiveHelper.getMediumSpacing(context),
              bottom:
                  chatProvider.chatState == ChatState.loading
                      ? ResponsiveHelper.getLargeSpacing(context) * 2
                      : ResponsiveHelper.getMediumSpacing(context),
            ),
            itemCount: chatProvider.chatHistory.length,
            itemBuilder: (context, index) {
              final message = chatProvider.chatHistory[index];
              return MessageBubble(message);
            },
          ),
        );
      },
    );
  }
}
