import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../helpers/responsive_helper.dart';

/// Widget untuk menampilkan baris informasi dalam summary profile
class SummaryRow extends StatelessWidget {
  const SummaryRow({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.getSmallSpacing(context)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getCardBorderRadius(context),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0x08000000),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: ResponsiveHelper.getIconSize(context) * 1.4,
            height: ResponsiveHelper.getIconSize(context) * 1.4,
            decoration: const BoxDecoration(
              color: Color(0xFF7C3AED),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: ResponsiveHelper.getIconSize(context) * 0.7,
            ),
          ),
          SizedBox(width: ResponsiveHelper.getSmallSpacing(context)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: ResponsiveHelper.getCaptionFontSize(context),
                    color: Colors.black45,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: ResponsiveHelper.getBodyFontSize(context),
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget untuk menampilkan BMI gauge card
class BmiGaugeCard extends StatelessWidget {
  const BmiGaugeCard({
    super.key,
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
      padding: EdgeInsets.all(ResponsiveHelper.getSmallSpacing(context) * 1.5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getCardBorderRadius(context),
        ),
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
                  fontSize: ResponsiveHelper.getCaptionFontSize(context),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                '$bmiLabel - ${bmi.toStringAsFixed(1)}',
                style: GoogleFonts.poppins(
                  fontSize: ResponsiveHelper.getCaptionFontSize(context),
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.getSmallSpacing(context)),
          LayoutBuilder(
            builder: (context, c) {
              final w = c.maxWidth;
              final x = _norm(bmi) * w;
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: ResponsiveHelper.isSmallMobile(context) ? 8 : 10,
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
                          height:
                              ResponsiveHelper.isSmallMobile(context) ? 8 : 10,
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
                          height:
                              ResponsiveHelper.isSmallMobile(context) ? 8 : 10,
                          color: const Color(0xFF22C55E),
                        ),
                      ),
                      Expanded(
                        flex: 50,
                        child: Container(
                          height:
                              ResponsiveHelper.isSmallMobile(context) ? 8 : 10,
                          color: const Color(0xFFF59E0B),
                        ),
                      ),
                      Expanded(
                        flex: 100,
                        child: Container(
                          height:
                              ResponsiveHelper.isSmallMobile(context) ? 8 : 10,
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
                    top: ResponsiveHelper.isSmallMobile(context) ? -18 : -20,
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal:
                                ResponsiveHelper.getSmallSpacing(context) *
                                0.75,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(
                              ResponsiveHelper.getSmallSpacing(context),
                            ),
                          ),
                          child: Text(
                            'You – $bmiText',
                            style: GoogleFonts.poppins(
                              fontSize:
                                  ResponsiveHelper.isSmallMobile(context)
                                      ? 9
                                      : 10,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(
                          height:
                              ResponsiveHelper.getSmallSpacing(context) * 0.75,
                        ),
                        Container(
                          width: ResponsiveHelper.getIconSize(context) * 0.67,
                          height: ResponsiveHelper.getIconSize(context) * 0.67,
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
          SizedBox(height: ResponsiveHelper.getSmallSpacing(context)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _cap('Underweight', context),
              _cap('Normal', context),
              _cap('Overweight', context),
              _cap('Obese', context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _cap(String t, BuildContext context) => Text(
    t,
    style: GoogleFonts.poppins(
      fontSize: ResponsiveHelper.isSmallMobile(context) ? 10 : 11,
      color: Colors.black54,
    ),
  );
}

/// Widget untuk menampilkan kotak note
class ProfileNoteCard extends StatelessWidget {
  const ProfileNoteCard({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.getMediumSpacing(context)),
      decoration: BoxDecoration(
        color: const Color(0xFFEDE4FF),
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getCardBorderRadius(context),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0x08000000),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: ResponsiveHelper.getCaptionFontSize(context),
          height: 1.4,
          color: const Color(0xFF5B5B5B),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
