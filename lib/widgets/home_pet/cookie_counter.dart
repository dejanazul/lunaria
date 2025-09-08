import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cookie_provider.dart';

class CookieCounter extends StatelessWidget {
  final VoidCallback? onTap;

  const CookieCounter({Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CookieProvider>(
      builder: (context, cookieProvider, _) {
        return GestureDetector(
          onTap: () {
            // Tambahkan cookie saat diklik
            cookieProvider.addCookies(1);

            // Panggil callback onTap jika tersedia
            if (onTap != null) {
              onTap!();
            }
          },
          child: SizedBox(
            width: 85,
            height: 33,
            child: Stack(
              children: [
                // Cookie counter background
                Positioned(
                  left: 3,
                  top: 4,
                  child: Container(
                    width: 82,
                    height: 25,
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
                  top: 9,
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
                    width: 33,
                    height: 33,
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/cookie_icon_new.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                // Animate shimmer effect when tapped (optional)
                if (cookieProvider.cookies % 10 == 0 &&
                    cookieProvider.cookies > 0)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.0),
                            Colors.white.withOpacity(0.3),
                            Colors.white.withOpacity(0.0),
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
