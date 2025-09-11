import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lunaria/constants/colors.dart';
import 'package:lunaria/providers/signup_data_provider.dart';
import 'package:lunaria/widgets/auth/auth_components.dart';
import 'package:provider/provider.dart';

import '../profile/my_profile_weight_page.dart';

class MyProfileHeightPage extends StatefulWidget {
  const MyProfileHeightPage({super.key});

  @override
  State<MyProfileHeightPage> createState() => _MyProfileHeightPageState();
}

class _MyProfileHeightPageState extends State<MyProfileHeightPage> {
  int? _height; // cm

  // ---------- UI helper: info card ----------
  Widget _buildInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            alignment: Alignment.center,
            child: const Icon(
              Icons.touch_app_rounded,
              size: 18,
              color: Colors.black54,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'We need this to calculate your BMI',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Your plan is created according to the body mass index',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Picker ----------
  Future<void> _showHeightPicker() async {
    int temp = _height ?? 160;

    // Dimensi & offset agar overlay tidak menimpa header picker
    const double sheetHeight = 340;
    const double headerHeight = 50; // tinggi area Cancel | Done
    const double cardGap = 12; // jarak overlay ke bibir sheet
    const double cardSidePadding = 24;
    const double buttonHeight = 56; // tinggi tombol Next abu
    const double cardHeightApprox = 70; // tinggi perkiraan card info
    const double overlayHeight =
        cardHeightApprox + 12 + buttonHeight; // card + spacer + button

    const double overlayLift =
        16; // ↓ turunin overlay 16px (lebih mepet ke picker)

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
          child: Material(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            clipBehavior: Clip.none, // penting: biar overlay boleh keluar
            child: SizedBox(
              height: sheetHeight,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // ====== Header + picker wheel ======
                  Column(
                    children: [
                      Container(
                        height: headerHeight,
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
                                setState(() => _height = temp);
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
                        child: CupertinoPicker(
                          itemExtent: 40,
                          scrollController: FixedExtentScrollController(
                            initialItem: (temp - 100).clamp(0, 150),
                          ),
                          onSelectedItemChanged: (i) => temp = 100 + i,
                          children: List.generate(150, (i) {
                            final cm = 100 + i; // 100..249 cm
                            return Center(
                              child: Text(
                                '$cm cm',
                                style: GoogleFonts.poppins(fontSize: 20),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),

                  // ====== OVERLAY: card + Next (abu) mepet di atas picker ======
                  Positioned(
                    left: cardSidePadding,
                    right: cardSidePadding,
                    // geser keluar di atas bibir sheet: total tinggi overlay + gap + header
                    // dikurang overlayLift agar lebih rendah (mepet)
                    top:
                        -(overlayHeight + cardGap + headerHeight - overlayLift),
                    child: AbsorbPointer(
                      absorbing: true, // disabled saat picker terbuka
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildInfoCard(),
                          const SizedBox(height: 12),
                          // Tombol disabled custom + shadow agar tidak "kependem"
                          Container(
                            height: buttonHeight,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEDEDED),
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x22000000),
                                  blurRadius: 10,
                                  offset: Offset(0, 3),
                                ),
                              ],
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
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _saveHeight() {
    if (_height == null) return;

    final signupProvider = Provider.of<SignupDataProvider>(
      context,
      listen: false,
    );
    signupProvider.updateHeight(_height!.toDouble());

    // Debug print the data
    signupProvider.debugPrintData();

    // Navigate to next page
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MyProfileWeightPage(heightCm: _height!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canNext = _height != null;

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
                'What is your height?',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 80),

              // “Type here” / value (tap buka picker)
              GestureDetector(
                onTap: _showHeightPicker,
                behavior: HitTestBehavior.opaque,
                child: Column(
                  children: [
                    Text(
                      _height == null ? 'Type here' : '$_height cm',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color:
                            _height == null
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

      // Bawah layar: info card di atas tombol Next (berdekatan)
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildInfoCard(),
              const SizedBox(height: 12),
              canNext
                  ? GradientButton(text: 'Next', onTap: _saveHeight)
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
            ],
          ),
        ),
      ),
    );
  }
}
