import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.title,
    required this.children,
    this.maxWidth = 420,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
  });

  final String title;
  final List<Widget> children;
  final double maxWidth;
  final EdgeInsets padding;

  // static const double _logoW = 182;
  // static const double _logoH = 60;
  static const double _spaceLogoToTitle = 24;
  static const double _spaceTitleToFirstField = 16;
  static const double _bottomSafe = 24;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: SingleChildScrollView(
              padding: padding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // LOGO (ukuran fix, center)
                  // Center(
                  //   child: SizedBox(
                  //     width: _logoW,
                  //     height: _logoH,
                  //     // Ganti image dengan Text sebagai placeholder karena logo belum ada
                  //     child: Text(
                  //       'Lunaria',
                  //       style: GoogleFonts.poppins(
                  //         fontSize: 28,
                  //         fontWeight: FontWeight.bold,
                  //         color: const Color(0xFF913F9E),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(height: _spaceLogoToTitle),

                  // TITLE (ukuran fix)
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: _spaceTitleToFirstField),

                  // KONTEN KHUSUS HALAMAN
                  ...children,

                  const SizedBox(height: _bottomSafe),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
