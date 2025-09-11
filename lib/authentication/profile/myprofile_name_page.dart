import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lunaria/authentication/login_page.dart';
import 'package:lunaria/widgets/auth/auth_components.dart';
import '../profile/my_profile_name_input_page.dart';

class MyProfileNamePage extends StatelessWidget {
  const MyProfileNamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // sesuai mock
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF5F5F5),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Title (dua baris, center)
                  Text(
                    "Let’s personalize\nyour plan",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      height: 1.15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Deskripsi
                  Text(
                    "To activate your Lunaria plan we require some of your health and other sensitive information (such as BMI, ethnicity). This is essentials to personalize your experience and cannot be exclude from our services. You may withdraw your consent in the profile.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      height: 1.6,
                      color: const Color(0xFF6B6B6B),
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  const SizedBox(height: 300),

                  // Tombol 1: I AGREE (gradien)
                  GradientButton(
                    text: 'I AGREE',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const MyProfileNameInputPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),

                  // Tombol 2: NOT RIGHT NOW (abu, bold)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE6E6E6),
                      foregroundColor: Colors.black,
                      minimumSize: const Size.fromHeight(54),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 4,
                      shadowColor: const Color(0x33000000),
                    ),
                    onPressed: () {
                      // TODO: aksi kalau user skip
                    },
                    child: Text(
                      'NOT RIGHT NOW',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Link ke Login
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                        children: [
                          const TextSpan(text: "Already Have an Account? "),
                          TextSpan(
                            text: "LOGIN HERE",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: const Color(0xFF004577),
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (_) => const LoginPage(),
                                  ),
                                  (route) => false,
                                );
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
