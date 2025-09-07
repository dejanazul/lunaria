import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cookie_provider.dart';

class CookieCounter extends StatelessWidget {
  const CookieCounter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CookieProvider>(
      builder: (context, cookieProvider, _) {
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
              Positioned(
                left: 39,
                top: 6,
                child: Text(
                  cookieProvider.cookies.toString(),
                  style: const TextStyle(
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
      },
    );
  }
}
