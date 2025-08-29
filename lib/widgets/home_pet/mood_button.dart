import 'package:flutter/material.dart';

class MoodButton extends StatelessWidget {
  const MoodButton({super.key});

  @override
  Widget build(BuildContext context) {
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
}
