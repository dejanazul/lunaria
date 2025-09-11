import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lunaria/constants/colors.dart';
import 'package:lunaria/providers/signup_data_provider.dart';
import 'package:lunaria/widgets/auth/auth_components.dart';
import 'package:provider/provider.dart';
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
            fontSize: 23,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: Color(0x11000000)),
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text(
                'Do you relate to the\nstatement below?',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 100),

              // Quote card
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 18),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 30,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xDDE3E7EE), // abu2 kebiruan lembut
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Hidup itu kadang-kadang kalo ga kadang ya kidding',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  // bubble quote
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: Color(0xFFC9D0DB),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.format_quote_rounded,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 230),

              // Yes / No options
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
                  const SizedBox(width: 16),
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

              const Spacer(),

              // Next button
              SafeArea(
                top: false,
                minimum: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                child:
                    canNext
                        ? GradientButton(text: 'Next', onTap: _saveYesNo)
                        : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black.withOpacity(0.4),
                            minimumSize: const Size.fromHeight(54),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 4,
                            shadowColor: const Color(0x33000000),
                          ),
                          onPressed: null,
                          child: Text(
                            'Next',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.black.withOpacity(0.4),
                            ),
                          ),
                        ),
              ),
            ],
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

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        height: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(color: dotBg, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: Icon(icon, size: 26, color: dotIcon),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
