import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 158,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Message bubble
          // Container(
          //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          //   decoration: BoxDecoration(
          //     color: const Color(0xFFE9E9EB),
          //     borderRadius: BorderRadius.circular(18),
          //   ),
          //   child: const Text(
          //     'Hop hop! 🐇 I\'m so glad you\'re here!',
          //     style: TextStyle(
          //       fontFamily: 'Poppins',
          //       fontSize: 17,
          //       fontWeight: FontWeight.w400,
          //       color: Colors.black,
          //       height: 1.29,
          //     ),
          //   ),
          // ),
          // Message tail
          Container(
            margin: const EdgeInsets.only(right: 5),
            child: CustomPaint(
              painter: MessageTailPainter(),
              size: const Size(16, 20),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for message bubble tail
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
