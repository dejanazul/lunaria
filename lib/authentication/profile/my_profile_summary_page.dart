import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lunaria/providers/signup_data_provider.dart';
import 'package:lunaria/widgets/auth/auth_components.dart';
import 'package:lunaria/widgets/auth/safe_profile_components.dart';
import 'package:provider/provider.dart';
import '../../helpers/responsive_helper.dart';
import 'CreatingPlanPage.dart';
import 'plan_result_page.dart';

class MyProfileSummaryPage extends StatelessWidget {
  const MyProfileSummaryPage({
    super.key,
    required this.heightCm,
    required this.weightKg,
    required this.lifestyle,
    required this.activities,
    required this.periodCycleText,
  });

  final int heightCm;
  final double weightKg;
  final String lifestyle; // <- isian dari step Lifestyle
  final String activities; // <- isian dari step Activities
  final String periodCycleText; // contoh: "6 days"

  // ===== BMI helpers
  double get bmi {
    final h = heightCm / 100.0;
    return weightKg / (h * h);
  }

  String get bmiLabel {
    final v = bmi;
    if (v < 18.5) return 'Underweight';
    if (v < 25) return 'Normal';
    if (v < 30) return 'Overweight';
    return 'Obese';
  }

  Color get bmiColor {
    final v = bmi;
    if (v < 18.5) return const Color(0xFF6EC8F1);
    if (v < 25) return const Color(0xFF22C55E);
    if (v < 30) return const Color(0xFFF59E0B);
    return const Color(0xFFEF4444);
  }

  @override
  Widget build(BuildContext context) {
    // Debug info untuk melihat nilai-nilai penting
    debugPrint('MyProfileSummaryPage: build method running');
    debugPrint('BMI: $bmi, Height: $heightCm cm, Weight: $weightKg kg');
    debugPrint('Lifestyle: $lifestyle, Activities: $activities');

    // Debugging screen dimensions
    final screenSize = MediaQuery.of(context).size;
    debugPrint('Screen size: ${screenSize.width} x ${screenSize.height}');
    debugPrint('Safe area: ${MediaQuery.of(context).padding}');

    SignupDataProvider? signupDataProvider;
    try {
      signupDataProvider = Provider.of<SignupDataProvider>(
        context,
        listen: false,
      );

      debugPrint('Provider - Lifestyle: ${signupDataProvider.lifestyle}');
      debugPrint(
        'Provider - Activities: ${signupDataProvider.preferredActivities}',
      );
      debugPrint('Provider - PeriodLength: ${signupDataProvider.periodLength}');
    } catch (e) {
      debugPrint('Error accessing SignupDataProvider: $e');
      // Tetap lanjutkan build dengan nilai dari constructor
    }

    // Basic scaffold for testing
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F6F6),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'My Profile',
          style: GoogleFonts.poppins(
            fontSize: 18.0, // Nilai fixed untuk memastikan tampilan konsisten
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
            size: 20.0, // Nilai fixed untuk memastikan tampilan konsisten
          ),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: ResponsiveHelper.getMaxContentWidth(context),
            ),
            child: ListView(
              padding: EdgeInsets.symmetric(
                horizontal:
                    16.0, // Gunakan nilai fixed untuk memastikan padding konsisten
                vertical:
                    16.0, // Gunakan nilai fixed untuk memastikan padding konsisten
              ),
              children: [
                Center(
                  child: Text(
                    'Summary of your\nfitness level',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: ResponsiveHelper.getTitleFontSize(context),
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: ResponsiveHelper.getMediumSpacing(context)),

                // ===== BMI card (menggunakan SafeBmiGaugeCard untuk mencegah crash)
                SafeBmiGaugeCard(
                  bmi: bmi.isNaN || bmi.isInfinite ? 21.5 : bmi,
                  bmiLabel: bmiLabel,
                  color: bmiColor,
                ),

                SizedBox(height: 24), // Fixed height untuk spacing konsisten
                // ===== Lifestyle (tampilkan value)
                SafeSummaryRow(
                  icon: Icons.desktop_windows_rounded,
                  title: 'Lifestyle',
                  value: signupDataProvider?.lifestyle ?? lifestyle,
                ),
                const SizedBox(height: 16), // Fixed height
                // ===== Activities (tampilkan value)
                SafeSummaryRow(
                  icon: Icons.sports_kabaddi_rounded,
                  title: 'Activities',
                  value:
                      signupDataProvider?.preferredActivities?.join(', ') ??
                      activities,
                ),
                const SizedBox(height: 16), // Fixed height
                // ===== Period Cycle (tampilkan "6 days", dst)
                SafeSummaryRow(
                  icon: Icons.water_drop_rounded,
                  title: 'Period Cycle',
                  value:
                      '${signupDataProvider?.periodLength ?? periodCycleText} days',
                ),

                // Mengurangi space yang berlebihan
                SizedBox(height: ResponsiveHelper.getMediumSpacing(context)),

                // Note dengan Container langsung untuk menghindari error dari komponen
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDE4FF),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x08000000),
                        offset: Offset(0, 2),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Text(
                    "You can update all this info anytime in your profile, so don't worry if something changes — just head to your profile page and adjust it whenever you need.",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      height: 1.4,
                      color: const Color(0xFF5B5B5B),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16), // Fixed height
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Material(
        elevation: 4.0,
        color: const Color(0xFFF6F6F6),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 16.0,
            ),
            child: GradientButton(
              text: 'Next',
              onTap: () {
                // Debug print untuk memastikan button berfungsi
                debugPrint('Next button tapped!');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => CreatingPlanPage(
                          nextPage: const PlanResultPage(),
                          totalDuration: const Duration(seconds: 6),
                        ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
