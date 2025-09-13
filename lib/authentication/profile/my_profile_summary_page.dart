import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lunaria/providers/signup_data_provider.dart';
import 'package:lunaria/widgets/auth/auth_components.dart';
import 'package:provider/provider.dart';
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
    // final bmiStr = bmi.toStringAsFixed(1).replaceAll('.', ',');
    final signupDataProvider = Provider.of<SignupDataProvider>(
      context,
      listen: false,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F6F6),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'My Profile',
          style: GoogleFonts.poppins(
            fontSize: 20,
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
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          children: [
            Center(
              child: Text(
                'Summary of your\nfitness level',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ===== BMI card
            _BmiGaugeCard(bmi: bmi, bmiLabel: bmiLabel, color: bmiColor),

            const SizedBox(height: 20),

            // ===== Lifestyle (tampilkan value)
            _SummaryRow(
              icon: Icons.desktop_windows_rounded,
              title: 'Lifestyle',
              value: signupDataProvider.lifestyle ?? "Not set",
            ),
            const SizedBox(height: 16),

            // ===== Activities (tampilkan value)
            _SummaryRow(
              icon: Icons.sports_kabaddi_rounded,
              title: 'Activities',
              value:
                  signupDataProvider.preferredActivities?.join(', ') ??
                  "Not set",
            ),
            const SizedBox(height: 16),

            // ===== Period Cycle (tampilkan "6 days", dst)
            _SummaryRow(
              icon: Icons.water_drop_rounded,
              title: 'Period Cycle',
              value: '${signupDataProvider.periodLength ?? 0} days',
            ),

            const SizedBox(height: 270),

            // note
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFEDE4FF),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                "You can update all this info anytime in your profile, so don't worry if something changes — just head to your profile page and adjust it whenever you need.",
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  height: 1.35,
                  color: const Color(0xFF5B5B5B),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
          child: GradientButton(
            text: 'Next',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => CreatingPlanPage(
                        nextPage:
                            const PlanResultPage(), // ganti dengan halaman hasilmu
                        totalDuration: const Duration(seconds: 6), // opsional
                      ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// ====== komponen pendukung ======

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(
            color: Color(0xFF7C3AED),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.black45,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BmiGaugeCard extends StatelessWidget {
  const _BmiGaugeCard({
    required this.bmi,
    required this.bmiLabel,
    required this.color,
  });

  final double bmi;
  final String bmiLabel;
  final Color color;

  double _norm(double v) {
    const min = 10.0, max = 40.0;
    final clamped = v.clamp(min, max);
    return (clamped - min) / (max - min);
  }

  @override
  Widget build(BuildContext context) {
    final bmiText = bmi.toStringAsFixed(1).replaceAll('.', ',');
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Body Mass Index (BMI)',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                '$bmiLabel - ${bmi.toStringAsFixed(1)}',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LayoutBuilder(
            builder: (context, c) {
              final w = c.maxWidth;
              final x = _norm(bmi) * w;
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 185,
                        child: Container(
                          height: 10,
                          decoration: const BoxDecoration(
                            color: Color(0xFF6EC8F1),
                            borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(6),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 65,
                        child: Container(
                          height: 10,
                          color: const Color(0xFF22C55E),
                        ),
                      ),
                      Expanded(
                        flex: 50,
                        child: Container(
                          height: 10,
                          color: const Color(0xFFF59E0B),
                        ),
                      ),
                      Expanded(
                        flex: 100,
                        child: Container(
                          height: 10,
                          decoration: const BoxDecoration(
                            color: Color(0xFFEF4444),
                            borderRadius: BorderRadius.horizontal(
                              right: Radius.circular(6),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    left: x.clamp(0.0, w) - 8,
                    top: -20,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'You – $bmiText',
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: color, width: 3),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _cap('Underweight'),
              _cap('Normal'),
              _cap('Overweight'),
              _cap('Obese'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _cap(String t) =>
      Text(t, style: GoogleFonts.poppins(fontSize: 11, color: Colors.black54));
}
