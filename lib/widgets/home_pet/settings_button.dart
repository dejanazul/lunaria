import 'package:flutter/material.dart';

class SettingsButton extends StatelessWidget {
  const SettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
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
}
