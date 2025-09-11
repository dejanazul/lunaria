import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lunaria/constants/colors.dart';
import 'package:lunaria/providers/signup_data_provider.dart';
import 'package:lunaria/widgets/auth/auth_components.dart';
import 'package:provider/provider.dart';

import 'my_profile_summary_page.dart';

class MyProfileLastCycleLengthPage extends StatefulWidget {
  const MyProfileLastCycleLengthPage({
    super.key,
    required this.heightCm,
    required this.weightKg,
    this.lifestyleText = '', // ← opsional
    this.activitiesText = '', // ← opsional
  });

  final int heightCm;
  final double weightKg; // kg
  final String lifestyleText;
  final String activitiesText;

  @override
  State<MyProfileLastCycleLengthPage> createState() =>
      _MyProfileLastCycleLengthPageState();
}

class _MyProfileLastCycleLengthPageState
    extends State<MyProfileLastCycleLengthPage> {
  int? _days;

  Future<void> _showDaysPicker() async {
    const int minDay = 1;
    const int maxDay = 60;
    int temp = _days ?? 6;

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
                          setState(() => _days = temp);
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
                  child: Stack(
                    children: [
                      CupertinoPicker(
                        itemExtent: 40,
                        magnification: 1.05,
                        squeeze: 1.1,
                        useMagnifier: true,
                        scrollController: FixedExtentScrollController(
                          initialItem: (temp - minDay).clamp(
                            0,
                            maxDay - minDay,
                          ),
                        ),
                        onSelectedItemChanged: (i) => temp = minDay + i,
                        children: List.generate(maxDay - minDay + 1, (i) {
                          final v = minDay + i;
                          return Center(
                            child: Text(
                              '$v',
                              style: GoogleFonts.poppins(fontSize: 20),
                            ),
                          );
                        }),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 18),
                          child: IgnorePointer(
                            ignoring: true,
                            child: Text(
                              'days',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
    if (_days == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => MyProfileSummaryPage(
              heightCm: widget.heightCm,
              weightKg: widget.weightKg,
              lifestyle: widget.lifestyleText,
              activities: widget.activitiesText,
              periodCycleText: '${_days!} days',
            ),
      ),
    );
  }

  void _saveCycleDuration() {
    if (_days == null) return;

    final signupProvider = Provider.of<SignupDataProvider>(
      context,
      listen: false,
    );
    signupProvider.updateCycleDuration(_days!);

    signupProvider.debugPrintData();

    _goNext();
  }

  @override
  Widget build(BuildContext context) {
    final canNext = _days != null;

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
                'How long was your\nlast cycle?',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 80),
              GestureDetector(
                onTap: _showDaysPicker,
                child: Column(
                  children: [
                    Text(
                      _days == null ? 'Type Here' : '$_days',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color:
                            _days == null
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
                  ? GradientButton(text: 'Next', onTap: _saveCycleDuration)
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
