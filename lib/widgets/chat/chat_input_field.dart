import 'package:flutter/material.dart';
import 'package:lunaria/constants/app_colors.dart';
import 'package:lunaria/helpers/responsive_helper.dart';
import 'package:lunaria/providers/chat_history_provider.dart';
import 'package:provider/provider.dart';

class ChatInputField extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const ChatInputField({
    super.key,
    required this.controller,
    required this.onSend,
  });

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.getMediumSpacing(context),
        vertical: ResponsiveHelper.getSmallSpacing(context),
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE9E9EB), width: 1)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Text input
            Expanded(
              child: Consumer<ChatHistoryProvider>(
                builder: (context, chatProvider, child) {
                  final isLoading = chatProvider.chatState == ChatState.loading;

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
                      controller: widget.controller,
                      enabled: !isLoading,
                      decoration: InputDecoration(
                        hintText: 'Ketik pesan...',
                        hintStyle: TextStyle(
                          color: const Color(0xFF8E8E93),
                          fontFamily: 'Poppins',
                          fontSize: ResponsiveHelper.getBodyFontSize(context),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: ResponsiveHelper.getMediumSpacing(
                            context,
                          ),
                          vertical: ResponsiveHelper.getSmallSpacing(context),
                        ),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: ResponsiveHelper.getBodyFontSize(context),
                        color: Colors.black,
                      ),
                      onSubmitted: (_) => widget.onSend(),
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
                final isLoading = chatProvider.chatState == ChatState.loading;

                return Material(
                  color:
                      isLoading
                          ? AppColors.primary.withOpacity(0.7)
                          : AppColors.primary,
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.getCardBorderRadius(context),
                  ),
                  child: InkWell(
                    onTap: isLoading ? null : widget.onSend,
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
                        size: ResponsiveHelper.getIconSize(context) * 0.8,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
