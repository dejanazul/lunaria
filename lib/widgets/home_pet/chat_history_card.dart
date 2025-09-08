import 'package:flutter/material.dart';
import 'package:lunaria/helpers/responsive_helper.dart';
import 'package:lunaria/providers/chat_history_provider.dart';
import 'package:lunaria/screens/home_pet/chat_room.dart';
import 'package:provider/provider.dart';

class ChatHistoryCard extends StatefulWidget {
  final TextEditingController chatController;
  final Future<void> Function() sendMessage;

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
          bottom: chatProvider.isHistoryVisible ? 0 : -450,
          left: 0,
          right: 0,
          height: 250,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Message bubble from Luna
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.getLargeSpacing(context),
                    vertical: ResponsiveHelper.getSmallSpacing(context),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 13, 0, 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: 267,
                        child: _buildCustomMessageBubble(),
                      ),
                    ),
                  ),
                ),

                // Quick chat container - garis sederhana
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 1,
                        color: const Color(0xFF901DA1),
                      ),
                      const SizedBox(height: 16),
                      _buildKeyboardButton(),
                    ],
                  ),
                ),

                SizedBox(height: ResponsiveHelper.getMediumSpacing(context)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildKeyboardButton() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ChatRoom()),
        );
      },
      child: Container(
        width: 300,
        height: 32,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFF913F9E), width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.keyboard, size: 20, color: Colors.black),
      ),
    );
  }

  // Custom message bubble sesuai Figma
  Widget _buildCustomMessageBubble() {
    return SizedBox(
      width: 267, // Width dari Figma
      height: 56, // Height dari Figma
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Main bubble
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ), // Padding dari Figma
            decoration: BoxDecoration(
              color: const Color(0xFFE9E9EB), // Warna dari Figma
              borderRadius: BorderRadius.circular(
                18,
              ), // Border radius dari Figma
            ),
            child: const Text(
              "Hop hop! 🐇 I'm so glad you're here!",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                fontSize: 15,
                height: 1.5714285714285714, // Line height exact dari Figma
                letterSpacing: -0.41, // Letter spacing dari Figma
                color: Color(0xFF000000), // Warna text dari Figma
              ),
              textAlign: TextAlign.left, // Text align dari Figma
            ),
          ),
          // Tail positioned exactly as in Figma
          Positioned(
            left: -5, // x position dari Figma
            top: 14, // y position dari Figma
            child: CustomPaint(
              painter: _CustomTailPainter(),
              size: const Size(16.42, 20.32), // Exact dimensions dari Figma
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter untuk tail message bubble sesuai Figma
class _CustomTailPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = const Color(0xFFE9E9EB) // Sama dengan warna bubble
          ..style = PaintingStyle.fill;

    final path = Path();
    // Membuat tail yang menunjuk ke kiri sesuai desain Figma
    // Tail berbentuk seperti ekor speech bubble yang natural
    path.moveTo(size.width, 0); // Mulai dari kanan atas
    path.lineTo(size.width * 0.3, size.height * 0.4); // Ke dalam bubble
    path.lineTo(0, size.height); // Ke ujung kiri bawah (pointing tip)
    path.lineTo(size.width * 0.7, size.height * 0.6); // Kembali ke bubble
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
