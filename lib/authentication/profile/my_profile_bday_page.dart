import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lunaria/constants/colors.dart';
import 'package:lunaria/providers/signup_data_provider.dart';
import 'package:lunaria/widgets/auth/auth_components.dart';
import 'package:provider/provider.dart';
import '../profile/my_profile_activities_page.dart';

class MyProfileBdayPage extends StatefulWidget {
  const MyProfileBdayPage({super.key});

  @override
  State<MyProfileBdayPage> createState() => _MyProfileBdayPageState();
}

class _MyProfileBdayPageState extends State<MyProfileBdayPage> {
  DateTime? _selected;
  bool _isPickerOpen = false; // untuk mengangkat tombol Next saat picker tampil

  // Format: 14 November 2003
  String _fmt(DateTime d) {
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

  Future<void> _showCupertinoPicker() async {
    final now = DateTime.now();
    DateTime temp = _selected ?? DateTime(now.year - 18, now.month, now.day);

    setState(() => _isPickerOpen = true);

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (ctx) {
        return SafeArea(
          top: false,
          child: SizedBox(
            height: 320,
            child: Column(
              children: [
                // Header Cancel / Done
                Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
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
                          setState(() => _selected = temp);
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

                // Picker wheel
                Expanded(
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: temp,
                    minimumDate: DateTime(1900, 1, 1),
                    maximumDate: now,
                    onDateTimeChanged: (d) => temp = d,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).whenComplete(() {
      if (mounted) setState(() => _isPickerOpen = false);
    });
  }

  void _saveBirthday() {
    if (_selected == null) return;

    // Get the SignupDataProvider and update the birthday
    final signupProvider = Provider.of<SignupDataProvider>(
      context,
      listen: false,
    );
    signupProvider.updateBirthDate(_selected!);

    // Navigate to next page
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const MyProfileActivitiesPage()));
  }

  @override
  Widget build(BuildContext context) {
    final canNext = _selected != null;

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
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              // Pertanyaan
              Text(
                "When is your birthday?",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 80),

              // "Type here" / tanggal + underline (tanpa TextField)
              GestureDetector(
                onTap: _showCupertinoPicker,
                behavior: HitTestBehavior.opaque,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 260),
                    child: Column(
                      children: [
                        Text(
                          _selected == null ? 'Type here' : _fmt(_selected!),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight:
                                _selected == null
                                    ? FontWeight.w500
                                    : FontWeight.w600, // value lebih tebal
                            color:
                                _selected == null
                                    ? const Color(0xFFBEBEBE)
                                    : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: Color(0xFFBEBEBE),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const Spacer(),

              // Tombol Next di dalam body, naik saat picker tampil
              AnimatedPadding(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                padding: EdgeInsets.only(
                  bottom: _isPickerOpen ? 320 : 0,
                ), // sesuaikan tinggi sheet
                child: SafeArea(
                  top: false,
                  minimum: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                  child:
                      canNext
                          ? GradientButton(text: 'Next', onTap: _saveBirthday)
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
