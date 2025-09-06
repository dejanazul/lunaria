import 'package:flutter/material.dart';

class CookieCounter extends StatelessWidget {
  final int count;
  const CookieCounter({required this.count, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset('assets/images/cookie_icon.png', width: 24, height: 24),
        const SizedBox(width: 4),
        Text(
          count.toString(),
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Colors.brown,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
