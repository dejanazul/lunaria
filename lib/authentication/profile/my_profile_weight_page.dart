import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lunaria/constants/colors.dart';
import 'package:lunaria/providers/signup_data_provider.dart';
import 'package:lunaria/widgets/auth/auth_components.dart';
import 'package:provider/provider.dart';

import 'my_profile_last_period_page.dart';

class MyProfileWeightPage extends StatefulWidget {
  const MyProfileWeightPage({
    super.key,
    required this.heightCm,
    this.lifestyleText = '',
    this.activitiesText = '',
  });

  final int heightCm;
  final String lifestyleText;
  final String activitiesText;

  @override
  State<MyProfileWeightPage> createState() => _MyProfileWeightPageState();
}

class _MyProfileWeightPageState extends State<MyProfileWeightPage> {
  // Nilai berat disimpan DALAM KG (1 desimal) agar konsisten untuk BMI
  double? _weightKg;
  bool _displayKg = true; // preferensi tampilan field (kg/lb)

  // ===== util konversi
  double _kgToLb(double kg) => kg * 2.2046226218;
  double _lbToKg(double lb) => lb / 2.2046226218;

  // ===== kartu info default (sebelum ada berat)
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
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F2),
              borderRadius: BorderRadius.circular(8),
            ),
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
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Your plan is created according to the body mass index',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
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

  // ===== kartu hasil BMI setelah berat dipilih
  Widget _buildBmiCard() {
    if (_weightKg == null) return _buildInfoCard();
    final h = widget.heightCm / 100.0;
    final bmi = _weightKg! / (h * h);
    String label;
    if (bmi < 18.5) {
      label = 'underweight';
    } else if (bmi < 25) {
      label = 'normal';
    } else if (bmi < 30) {
      label = 'overweight';
    } else {
      label = 'obese';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFEFFAF1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: Color(0xFF22C55E),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your current BMI is ${bmi.toStringAsFixed(1).replaceAll('.', ',')}  which is $label',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  label == 'normal'
                      ? "You're in great shape! We will use this index to personalize your workouts plan"
                      : 'We will tailor your plan based on this index',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
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

  // ===== bottom sheet: picker 4 kolom + overlay card + Next abu di ATAS picker
  Future<void> _showWeightPicker() async {
    bool localIsKg = _displayKg;

    // nilai awal saat buka sheet mengikuti unit tampilan
    double display =
        _weightKg == null
            ? (localIsKg ? 60.0 : 132.0)
            : (localIsKg ? _weightKg! : _kgToLb(_weightKg!));

    int intPart = display.floor();
    int decPart = ((display * 10).round() % 10);
    int unitIndex = localIsKg ? 0 : 1; // 0=kg, 1=lb

    // range integer
    const int minIntKg = 30, maxIntKg = 200; // 30.0..200.9 kg
    const int minIntLb = 66, maxIntLb = 440; // ~30..200 kg dalam lb

    // —— ukuran elemen sheet & overlay (disetel ulang agar TIDAK menimpa picker)
    const double sheetH = 360; // tinggi total bottom sheet
    const double headerH = 50; // tinggi header Cancel/Done
    const double btnH = 56; // tinggi tombol Next abu overlay
    const double infoCardApprox = 92; // PERKIRAAN tinggi kartu info
    const double sidePad = 24;
    const double extraLift = 8.0; // fine-tune naik/turun overlay

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        FixedExtentScrollController makeIntCtrl() {
          final min = localIsKg ? minIntKg : minIntLb;
          final init =
              (intPart.clamp(min, localIsKg ? maxIntKg : maxIntLb) - min);
          return FixedExtentScrollController(initialItem: init);
        }

        FixedExtentScrollController makeDecCtrl() =>
            FixedExtentScrollController(initialItem: decPart.clamp(0, 9));

        FixedExtentScrollController makeUnitCtrl() =>
            FixedExtentScrollController(initialItem: unitIndex);

        var intCtrl = makeIntCtrl();
        var decCtrl = makeDecCtrl();
        var unitCtrl = makeUnitCtrl();

        void convertOnUnitChange(int newIndex, StateSetter setModal) {
          if (unitIndex == newIndex) return;
          final current = intPart + decPart / 10.0; // dalam unit lama
          final converted =
              (newIndex == 0) ? _lbToKg(current) : _kgToLb(current);
          localIsKg = (newIndex == 0);
          unitIndex = newIndex;

          final min = localIsKg ? minIntKg : minIntLb;
          final max = localIsKg ? maxIntKg : maxIntLb;
          final clipped = converted.clamp(min.toDouble(), max.toDouble());
          intPart = clipped.floor();
          decPart = ((clipped * 10).round() % 10);

          setModal(() {
            intCtrl.dispose();
            decCtrl.dispose();
            unitCtrl.dispose();
            intCtrl = makeIntCtrl();
            decCtrl = makeDecCtrl();
            unitCtrl = makeUnitCtrl();
          });
        }

        return StatefulBuilder(
          builder: (ctx, setModal) {
            return SafeArea(
              top: false,
              child: Material(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                clipBehavior: Clip.none,
                child: SizedBox(
                  height: sheetH,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Header + pickers
                      Column(
                        children: [
                          // Header
                          Container(
                            height: headerH,
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
                                    final min = localIsKg ? minIntKg : minIntLb;
                                    intPart = (min + intCtrl.selectedItem);
                                    decPart = decCtrl.selectedItem;
                                    final chosen =
                                        intPart +
                                        decPart / 10.0; // dalam unit lokal
                                    setState(() {
                                      _displayKg = (unitIndex == 0);
                                      _weightKg =
                                          _displayKg ? chosen : _lbToKg(chosen);
                                    });
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
                          // 4 kolom picker
                          Expanded(
                            child: Row(
                              children: [
                                const SizedBox(width: 8),
                                // integer
                                Expanded(
                                  flex: 4,
                                  child: CupertinoPicker(
                                    itemExtent: 40,
                                    magnification: 1.05,
                                    squeeze: 1.1,
                                    useMagnifier: true,
                                    scrollController: intCtrl,
                                    onSelectedItemChanged: (_) {},
                                    children: List.generate(
                                      (localIsKg
                                              ? (maxIntKg - minIntKg)
                                              : (maxIntLb - minIntLb)) +
                                          1,
                                      (i) => Center(
                                        child: Text(
                                          '${(localIsKg ? minIntKg : minIntLb) + i}',
                                          style: GoogleFonts.poppins(
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                // koma statis
                                SizedBox(
                                  width: 24,
                                  child: Center(
                                    child: Text(
                                      ',',
                                      style: GoogleFonts.poppins(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                // desimal
                                Expanded(
                                  flex: 3,
                                  child: CupertinoPicker(
                                    itemExtent: 40,
                                    magnification: 1.05,
                                    squeeze: 1.1,
                                    useMagnifier: true,
                                    scrollController: decCtrl,
                                    onSelectedItemChanged: (_) {},
                                    children: List.generate(
                                      10,
                                      (i) => Center(
                                        child: Text(
                                          '$i',
                                          style: GoogleFonts.poppins(
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                // unit (kg/lb)
                                SizedBox(
                                  width: 56,
                                  child: CupertinoPicker(
                                    itemExtent: 40,
                                    magnification: 1.05,
                                    squeeze: 1.1,
                                    useMagnifier: true,
                                    scrollController: unitCtrl,
                                    onSelectedItemChanged:
                                        (idx) =>
                                            convertOnUnitChange(idx, setModal),
                                    children: [
                                      Center(
                                        child: Text(
                                          'kg',
                                          style: GoogleFonts.poppins(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: Text(
                                          'lb',
                                          style: GoogleFonts.poppins(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Overlay: info card + Next (abu) -> dinaikkan sehingga TIDAK menimpa picker
                      Positioned(
                        left: sidePad,
                        right: sidePad,
                        // naikkan seluruh overlay (card + gap + button) dari bibir sheet
                        // headerH + infoCardApprox + 12(spasi) + btnH - extraLift
                        top:
                            -(headerH + infoCardApprox + 12 + btnH - extraLift),
                        child: AbsorbPointer(
                          absorbing: true,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildInfoCard(),
                              const SizedBox(height: 12),
                              Container(
                                height: btnH,
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
      },
    );
  }

  String _displayValue() {
    if (_weightKg == null) return 'Type here';
    final v = _displayKg ? _weightKg! : _kgToLb(_weightKg!);
    return '${v.toStringAsFixed(1).replaceAll('.', ',')} ${_displayKg ? 'kg' : 'lb'}';
  }

  void _saveBmi() {
    if (_weightKg == null) return;
    final h = widget.heightCm / 100.0;
    final bmi = _weightKg! / (h * h);

    final signupProvider = Provider.of<SignupDataProvider>(
      context,
      listen: false,
    );
    signupProvider.updateWeight(_weightKg!);
    signupProvider.updateBmi(bmi);

    // Debug print the data
    signupProvider.debugPrintData();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (_) => MyProfileLastPeriodPage(
              heightCm: widget.heightCm,
              weightKg: _weightKg!, // kirim KG
              lifestyleText: widget.lifestyleText,
              activitiesText: widget.activitiesText,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canNext = _weightKg != null;

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
                'What is your weight?',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 80),
              GestureDetector(
                onTap: _showWeightPicker,
                behavior: HitTestBehavior.opaque,
                child: Column(
                  children: [
                    Text(
                      _displayValue(),
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color:
                            _weightKg == null
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildBmiCard(), // info -> berubah jadi BMI card setelah Done
              const SizedBox(height: 12),
              canNext
                  ? GradientButton(text: 'Next', onTap: _saveBmi)
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
