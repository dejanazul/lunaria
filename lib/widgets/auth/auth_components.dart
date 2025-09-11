import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lunaria/constants/colors.dart';

class GradientButton extends StatelessWidget {
  const GradientButton({super.key, required this.text, required this.onTap});
  final String text;
  final VoidCallback onTap;

  

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryDark, AppColors.primary],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          minimumSize: const Size.fromHeight(54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: onTap,
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class ChipOr extends StatelessWidget {
  const ChipOr({super.key});
  @override
  Widget build(BuildContext context) {
    return Text(
      'Or',
      style: GoogleFonts.montserrat(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF616161),
      ),
    );
  }
}

class SocialButton extends StatelessWidget {
  const SocialButton({
    super.key,
    required this.asset,
    required this.text,
    required this.onTap,
  });

  final String asset;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Color(0xFFE0E0E0)),
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      onPressed: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Ganti dengan icon dari library sebagai placeholder
          Icon(
            asset.contains('google')
                ? Icons.g_mobiledata
                : asset.contains('facebook')
                ? Icons.facebook
                : Icons.apple,
            size: 20,
            color: const Color(0xFF616161),
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: GoogleFonts.montserrat(
              fontSize: 13, // ~12.8 dari Figma
              fontWeight: FontWeight.w400,
              height: 1.75, // 22.5 / 12.8
              color: const Color(0xFF616161),
            ),
          ),
        ],
      ),
    );
  }
}

class CenteredUnderlineField extends StatelessWidget {
  const CenteredUnderlineField({
    super.key,
    required this.controller,
    this.hint = 'Type here',
    this.onChanged,
    this.maxWidth = 260, // panjang garis (bisa kamu atur)
    this.focusedLineColor = Colors.black,
  });

  final TextEditingController controller;
  final String hint;
  final ValueChanged<String>? onChanged;
  final double maxWidth;
  final Color focusedLineColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 24, // sama seperti spec
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: const Color(0xFFBEBEBE),
            ),
            isDense: true,
            contentPadding: const EdgeInsets.only(top: 2, bottom: 6),
            border: const UnderlineInputBorder(),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFBEBEBE), width: 1),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: focusedLineColor, width: 1),
            ),
          ),
        ),
      ),
    );
  }
}
