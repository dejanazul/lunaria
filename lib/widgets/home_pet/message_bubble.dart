import 'package:flutter/material.dart';
import 'package:lunaria/constants/app_colors.dart';
import 'package:lunaria/models/chat_message.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage? message;

  const MessageBubble([this.message, Key? key]) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Special case untuk MessageBubble yang dipanggil tanpa message (misalnya dari home screen)
    if (message == null) {
      return SizedBox(
        width: 158,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Bubble chat (placeholder) berdasarkan desain Figma
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFE9E9EB), // Warna dari Figma
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Text(
                'Hop hop! 🐇 I\'m so glad you\'re here!',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14, // Ukuran font dari Figma
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  height: 1.57, // Line height dari Figma
                  letterSpacing: -0.4, // Letter spacing dari Figma
                ),
              ),
            ),
            // Message tail - menggunakan Transform alih-alih margin negatif
            Transform.translate(
              offset: const Offset(
                5,
                -5,
              ), // Menggunakan offset untuk memindahkan komponen
              child: CustomPaint(
                painter: MessageTailPainter(),
                size: const Size(16, 20),
              ),
            ),
          ],
        ),
      );
    } else {
      // Untuk pesan dalam chat room berdasarkan desain Figma
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment:
              message!.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!message!.isUser) _buildAvatar(),
            const SizedBox(width: 8),
            Flexible(
              child: Column(
                crossAxisAlignment:
                    message!.isUser
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                children: [
                  // Bubble dan tail
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Message bubble
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color:
                              message!.isUser
                                  ? AppColors
                                      .primary // Color dari Figma: #913F9E
                                  : const Color(0xFFE9E9EB), // Color dari Figma
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Text(
                          message!.text,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: message!.isUser ? 12 : 14, // Sesuai Figma
                            fontWeight: FontWeight.w400,
                            height:
                                message!.isUser ? 1.83 : 1.57, // Sesuai Figma
                            letterSpacing: message!.isUser ? -0.4 : -0.4,
                            color:
                                message!.isUser ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                      // Message tail - hanya untuk pesan Luna
                      if (!message!.isUser)
                        // Recipient message tail (Luna/left side)
                        Positioned(
                          left: -5,
                          top: 14,
                          child: CustomPaint(
                            painter: MessageTailPainter(),
                            size: const Size(16, 20),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (message!.isUser) _buildUserAvatar(),
          ],
        ),
      );
    }
  }

  Widget _buildAvatar() {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: AppColors.accent.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Text(
          "L",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildUserAvatar() {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Text(
          "U",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}

// Custom painter for recipient message bubble tail (Luna/left side)
class MessageTailPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = const Color(0xFFE9E9EB)
          ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width * 0.7, 0);
    path.lineTo(size.width, size.height * 0.6);
    path.lineTo(size.width * 0.3, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom painter for sender message bubble tail (User/right side)
class SenderMessageTailPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = AppColors.primary
          ..style = PaintingStyle.fill;

    final path = Path();
    // Membuat path dengan arah yang benar (tail menunjuk ke kanan)
    path.moveTo(0, 0);
    path.lineTo(size.width * 0.7, 0);
    path.lineTo(size.width, size.height * 0.6);
    path.lineTo(size.width * 0.3, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
