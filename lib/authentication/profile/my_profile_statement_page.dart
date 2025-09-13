import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lunaria/constants/colors.dart';
import 'package:lunaria/providers/signup_data_provider.dart';
import 'package:lunaria/widgets/auth/auth_components.dart';
import 'package:provider/provider.dart';
import '../../helpers/responsive_helper.dart';
import '../profile/my_profile_height_page.dart';

class MyProfileYesNoPage extends StatefulWidget {
  const MyProfileYesNoPage({super.key});

  @override
  State<MyProfileYesNoPage> createState() => _MyProfileYesNoPageState();
}

class _MyProfileYesNoPageState extends State<MyProfileYesNoPage> {
  String? _answer; // "yes" | "no"

  void _saveYesNo() {
    if (_answer == null) return;

    final signupProvider = Provider.of<SignupDataProvider>(
      context,
      listen: false,
    );

    // Debug print the data
    signupProvider.debugPrintData();

    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const MyProfileHeightPage()));
  }

  @override
  Widget build(BuildContext context) {
    final canNext = _answer != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'My Profile',
          style: GoogleFonts.poppins(
            fontSize: ResponsiveHelper.getHeadingFontSize(context),
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
            size: ResponsiveHelper.getIconSize(context) * 0.8,
          ),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: Color(0x11000000)),
        ),
      ),

      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: ResponsiveHelper.getMaxContentWidth(context),
            ),
            child: SingleChildScrollView(
              padding: ResponsiveHelper.getHorizontalPadding(context),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: ResponsiveHelper.getMediumSpacing(context)),

                  // Title
                  Text(
                    'Do you relate to the\nstatement below?',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: ResponsiveHelper.getTitleFontSize(context),
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),

                  SizedBox(
                    height: ResponsiveHelper.getAdaptiveSpacing(
                      context,
                      smallMobile: 60,
                      mobile: 100,
                      tablet: 120,
                    ),
                  ),

                  // Quote card with responsive design
                  Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          top: ResponsiveHelper.getIconSize(context) * 0.75,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveHelper.getMediumSpacing(
                            context,
                          ),
                          vertical: ResponsiveHelper.getLargeSpacing(context),
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xDDE3E7EE),
                          borderRadius: BorderRadius.circular(
                            ResponsiveHelper.getCardBorderRadius(context),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0x08000000),
                              offset: const Offset(0, 4),
                              blurRadius: 12,
                            ),
                          ],
                        ),
                        child: Text(
                          'Menurutmu, apakah olahraga penting?',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: ResponsiveHelper.getBodyFontSize(context),
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                            height: 1.4,
                          ),
                        ),
                      ),
                      // Quote bubble icon - responsive size
                      Container(
                        width: ResponsiveHelper.getIconSize(context) * 1.5,
                        height: ResponsiveHelper.getIconSize(context) * 1.5,
                        decoration: const BoxDecoration(
                          color: Color(0xFFC9D0DB),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x15000000),
                              offset: Offset(0, 2),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.format_quote_rounded,
                          color: Colors.white,
                          size: ResponsiveHelper.getIconSize(context) * 0.8,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: ResponsiveHelper.getAdaptiveSpacing(
                      context,
                      smallMobile: 100,
                      mobile: 140,
                      tablet: 180,
                    ),
                  ),

                  // Yes / No options dengan responsive design
                  Row(
                    children: [
                      Expanded(
                        child: _SelectCard(
                          label: 'Yes',
                          icon: Icons.check_rounded,
                          selected: _answer == 'yes',
                          onTap: () => setState(() => _answer = 'yes'),
                        ),
                      ),
                      SizedBox(
                        width: ResponsiveHelper.getMediumSpacing(context),
                      ),
                      Expanded(
                        child: _SelectCard(
                          label: 'No',
                          icon: Icons.close_rounded,
                          selected: _answer == 'no',
                          onTap: () => setState(() => _answer = 'no'),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: ResponsiveHelper.getLargeSpacing(context),
                  ),

                  // Next button
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveHelper.getSmallSpacing(context),
                    ),
                    child:
                        canNext
                            ? GradientButton(text: 'Next', onTap: _saveYesNo)
                            : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black.withOpacity(0.4),
                                minimumSize: Size.fromHeight(
                                  ResponsiveHelper.getButtonHeight(context),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    ResponsiveHelper.getCardBorderRadius(
                                          context,
                                        ) *
                                        0.7,
                                  ),
                                ),
                                elevation: 4,
                                shadowColor: const Color(0x33000000),
                              ),
                              onPressed: null,
                              child: Text(
                                'Next',
                                style: GoogleFonts.poppins(
                                  fontSize:
                                      ResponsiveHelper.getSubheadingFontSize(
                                        context,
                                      ),
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black.withOpacity(0.4),
                                ),
                              ),
                            ),
                  ),

                  // Extra padding for small screens
                  SizedBox(height: ResponsiveHelper.getMediumSpacing(context)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SelectCard extends StatelessWidget {
  const _SelectCard({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor = selected ? AppColors.primary : const Color(0xFFE0E0E0);
    final dotBg =
        selected
            ? AppColors.primary.withOpacity(0.15)
            : const Color(0xFFE9E9E9);
    final dotIcon = selected ? AppColors.primary : const Color(0xFFBDBDBD);
    final textColor = Colors.black87;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getCardBorderRadius(context),
        ),
        child: Ink(
          height: ResponsiveHelper.getAdaptiveSpacing(
            context,
            smallMobile: 120,
            mobile: 140,
            tablet: 160,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              ResponsiveHelper.getCardBorderRadius(context),
            ),
            border: Border.all(color: borderColor, width: selected ? 2 : 1),
            boxShadow: [
              BoxShadow(
                color: const Color(0x08000000),
                offset: const Offset(0, 2),
                blurRadius: 8,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: ResponsiveHelper.getIconSize(context) * 1.4,
                height: ResponsiveHelper.getIconSize(context) * 1.4,
                decoration: BoxDecoration(color: dotBg, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: Icon(
                  icon,
                  size: ResponsiveHelper.getIconSize(context) * 0.8,
                  color: dotIcon,
                ),
              ),
              SizedBox(height: ResponsiveHelper.getSmallSpacing(context)),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: ResponsiveHelper.getCaptionFontSize(context),
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
