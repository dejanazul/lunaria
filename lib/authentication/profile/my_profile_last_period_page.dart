import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lunaria/providers/signup_data_provider.dart';
import 'package:lunaria/widgets/auth/auth_components.dart';
import 'package:provider/provider.dart';

import '../../constants/app_colors.dart' show AppColors;
import 'my_profile_last_cycle_page.dart';

class MyProfileLastPeriodPage extends StatefulWidget {
  const MyProfileLastPeriodPage({
    super.key,
    required this.heightCm,
    required this.weightKg,
    this.lifestyleText = '', // ← opsional
    this.activitiesText = '', // ← opsional
  });

  final int heightCm;
  final double weightKg;
  final String lifestyleText;
  final String activitiesText;

  @override
  State<MyProfileLastPeriodPage> createState() =>
      _MyProfileLastPeriodPageState();
}

class _MyProfileLastPeriodPageState extends State<MyProfileLastPeriodPage> {
  DateTime? _date;

  String _formatDate(DateTime d) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    final dd = d.day.toString().padLeft(2, '0');
    return '$dd ${months[d.month - 1]} ${d.year}';
  }

  Future<void> _showDatePicker() async {
    final now = DateTime.now();
    final min = DateTime(now.year - 3, now.month, now.day);
    final max = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);

    DateTime temp = _date ?? now;
    if (temp.isBefore(min)) temp = min;
    if (temp.isAfter(max)) temp = max;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          top: false,
          child: SizedBox(
            height: 340,
            child: Column(
              children: [
                Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color(0x11000000)),
                    ),
                  ),
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          setState(() => _date = temp);
                          Navigator.pop(ctx);
                        },
                        child: Text(
                          'Done',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    minimumDate: min,
                    maximumDate: max,
                    initialDateTime: temp,
                    onDateTimeChanged: (d) => temp = d,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _goNext() {
    if (_date == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => MyProfileLastCycleLengthPage(
              heightCm: widget.heightCm,
              weightKg: widget.weightKg,
              lifestyleText: widget.lifestyleText,
              activitiesText: widget.activitiesText,
            ),
      ),
    );
  }

  void _saveLastPeriod() {
    if (_date == null) return;

    final signupProvider = Provider.of<SignupDataProvider>(
      context,
      listen: false,
    );
    signupProvider.updateLastCycle(_date!);

    // Debug print the data
    signupProvider.debugPrintData();

    _goNext();
  }

  @override
  Widget build(BuildContext context) {
    final canNext = _date != null;

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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 28),
              Text(
                'Enter the date of your\nlast period:',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 80),
              GestureDetector(
                onTap: _showDatePicker,
                child: Column(
                  children: [
                    Text(
                      _date == null ? 'Type Here' : _formatDate(_date!),
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color:
                            _date == null
                                ? const Color(0xFFBEBEBE)
                                : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0x26000000),
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
          child:
              canNext
                  ? GradientButton(text: 'Next', onTap: _saveLastPeriod)
                  : Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDEDED),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Next',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black38,
                      ),
                    ),
                  ),
        ),
      ),
    );
  }
}
