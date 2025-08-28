import 'package:flutter/material.dart';
import '../../components/bottom_nav.dart';
import '../../routes/routes.dart';

class VPHomeScreen extends StatefulWidget {
  const VPHomeScreen({super.key});

  @override
  State<VPHomeScreen> createState() => _VPHomeScreenState();
}

class _VPHomeScreenState extends State<VPHomeScreen> {
  int _currentIndex = 2; // Pet tab is selected

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF420D4A), Color(0xFF7B347E)],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Background pet illustration
              Positioned(
                top: -31,
                left: 0,
                right: 0,
                child: SizedBox(
                  height: 789,
                  width: 393,
                  child: Image.asset(
                    'assets/images/pet_background-4faf77.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Main pet character
              Positioned(
                top: 234,
                left: 2,
                child: SizedBox(
                  height: 386,
                  width: 386,
                  child: Image.asset(
                    'assets/images/pet_main_image.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Level indicator
              Positioned(top: 60, left: 17, child: _buildLevelIndicator()),

              // Cookie counter
              Positioned(top: 58, left: 153, child: _buildCookieCounter()),

              // Settings button
              Positioned(top: 60, right: 18, child: _buildSettingsButton()),

              // Mood button
              Positioned(top: 540, right: 20, child: _buildMoodButton()),

              // Message bubble
              Positioned(top: 150, right: 19, child: _buildMessageBubble()),

              // Bottom navigation
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: BottomNav(
                  currentIndex: _currentIndex,
                  onTap: (index) {
                    NavigationService.navigateToBottomNavScreen(
                      context,
                      index,
                      _currentIndex,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLevelIndicator() {
    return SizedBox(
      width: 126,
      height: 34,
      child: Stack(
        children: [
          // Level progress background
          Positioned(
            left: 17,
            top: 2,
            child: Container(
              width: 109,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF913F9E)),
              ),
            ),
          ),
          // Level progress fill
          Positioned(
            left: 7,
            top: 2,
            child: Container(
              width: 83,
              height: 20,
              decoration: BoxDecoration(
                color: const Color(0xFFE9CBEE),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF913F9E)),
              ),
            ),
          ),
          // Level text
          const Positioned(
            left: 30,
            top: 4,
            child: Text(
              'Level 2',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF901DA1),
              ),
            ),
          ),
          // Level icon
          Positioned(
            left: 0,
            top: 0,
            child: SizedBox(
              width: 32,
              height: 34,
              child: Image.asset(
                'assets/images/level_icon-13139c.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCookieCounter() {
    return SizedBox(
      width: 75,
      height: 28,
      child: Stack(
        children: [
          // Cookie counter background
          Positioned(
            left: 3,
            top: 4,
            child: Container(
              width: 72,
              height: 20,
              decoration: BoxDecoration(
                color: const Color(0xFFF2D6BA),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF553F35)),
              ),
            ),
          ),
          // Cookie count text
          const Positioned(
            left: 39,
            top: 6,
            child: Text(
              '10',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF553F35),
              ),
            ),
          ),
          // Cookie icon
          Positioned(
            left: 0,
            top: 0,
            child: SizedBox(
              width: 28,
              height: 28,
              child: ClipOval(
                child: Image.asset(
                  'assets/images/cookie_icon.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsButton() {
    return SizedBox(
      width: 24,
      height: 24,
      child: Stack(
        children: [
          // Settings background
          Positioned(
            left: 2,
            top: 2,
            child: Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: Color(0xFF913F9E),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Settings icon (dots)
          const Positioned(
            left: 0,
            top: 0,
            child: Icon(Icons.more_horiz, size: 24, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodButton() {
    return SizedBox(
      width: 55,
      height: 55,
      child: Stack(
        children: [
          // Mood button background
          Container(
            width: 55,
            height: 55,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF420D4A), Color(0xFF7B347E)],
              ),
              shape: BoxShape.circle,
            ),
          ),
          // Mood plus icon
          const Center(child: Icon(Icons.add, size: 32, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildMessageBubble() {
    return SizedBox(
      width: 158,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Message bubble
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFE9E9EB),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Text(
              'Hop hop! 🐇 I\'m so glad you\'re here!',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 17,
                fontWeight: FontWeight.w400,
                color: Colors.black,
                height: 1.29,
              ),
            ),
          ),
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
