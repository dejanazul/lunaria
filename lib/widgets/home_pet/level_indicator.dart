import 'package:flutter/material.dart';

class LevelIndicator extends StatelessWidget {
  const LevelIndicator({super.key});

  @override
  Widget build(BuildContext context) {
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
}
