import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lunaria/widgets/auth/auth_components.dart';
import '../profile/my_profile_name_input_page.dart';
import '../../helpers/responsive_helper.dart';

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
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
            size: ResponsiveHelper.getIconSize(context) * 0.8,
          ),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: ResponsiveHelper.getMaxContentWidth(context),
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal:
                    ResponsiveHelper.getHorizontalPadding(context).horizontal /
                    2,
                vertical:
                    ResponsiveHelper.getVerticalPadding(context).vertical / 2,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Title (dua baris, center)
                  Text(
                    "Let's personalize\nyour plan",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: ResponsiveHelper.getTitleFontSize(context),
                      height: 1.15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: ResponsiveHelper.getMediumSpacing(context)),

                  // Deskripsi
                  Text(
                    "To activate your Lunaria plan we require some of your health and other sensitive information (such as BMI, ethnicity). This is essentials to personalize your experience and cannot be exclude from our services. You may withdraw your consent in the profile.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: ResponsiveHelper.getCaptionFontSize(context),
                      height: 1.6,
                      color: const Color(0xFF6B6B6B),
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  SizedBox(
                    height: ResponsiveHelper.getAdaptiveSpacing(
                      context,
                      smallMobile: 120,
                      mobile: 250,
                      tablet: 300,
                    ),
                  ),

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
                  SizedBox(height: ResponsiveHelper.getSmallSpacing(context)),

                  // Tombol 2: NOT RIGHT NOW (abu, bold)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE6E6E6),
                      foregroundColor: Colors.black,
                      minimumSize: Size.fromHeight(
                        ResponsiveHelper.getButtonHeight(context),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          ResponsiveHelper.getCardBorderRadius(context) * 0.7,
                        ),
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
                        fontSize: ResponsiveHelper.getBodyFontSize(context),
                      ),
                    ),
                  ),

                  SizedBox(height: ResponsiveHelper.getLargeSpacing(context)),

                  // Link ke Login
                  SizedBox(height: ResponsiveHelper.getSmallSpacing(context)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
