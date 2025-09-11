import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lunaria/constants/colors.dart';
import 'package:lunaria/providers/signup_data_provider.dart';
import 'package:lunaria/widgets/auth/auth_components.dart';
import 'package:provider/provider.dart';
import '../profile/my_profile_statement_page.dart';

class MyProfileTypicalDayPage extends StatefulWidget {
  const MyProfileTypicalDayPage({super.key});

  @override
  State<MyProfileTypicalDayPage> createState() =>
      _MyProfileTypicalDayPageState();
}

class _MyProfileTypicalDayPageState extends State<MyProfileTypicalDayPage> {
  final List<_DayOption> options = const [
    _DayOption('At the Office', 'assets/icons/typical_day/office.png'),
    _DayOption('Walking Daily', 'assets/icons/typical_day/walking.png'),
    _DayOption(
      'Working Physically',
      'assets/icons/typical_day/muscle.png',
    ), // pakai otot
    _DayOption('Mostly at Home', 'assets/icons/typical_day/home.png'),
  ];

  String? _selected;

  void _typicalDay() {
    if (_selected == null) return;

    // Get the SignupDataProvider and update the name
    final signupProvider = Provider.of<SignupDataProvider>(
      context,
      listen: false,
    );
    signupProvider.updateLifestyle(_selected!);

    // Debug print the data
    signupProvider.debugPrintData();

    // Navigate to next page
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => MyProfileYesNoPage()));
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
        child: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                "What does your typical\nday look like?",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 250),

            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                itemCount: options.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, i) {
                  final o = options[i];
                  final checked = _selected == o.title;
                  return _DayTile(
                    option: o,
                    checked: checked,
                    onTap: () => setState(() => _selected = o.title),
                  );
                },
              ),
            ),

            SafeArea(
              top: false,
              minimum: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              child:
                  canNext
                      ? GradientButton(text: 'Next', onTap: _typicalDay)
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
    );
  }
}

class _DayTile extends StatelessWidget {
  const _DayTile({
    required this.option,
    required this.checked,
    required this.onTap,
  });

  final _DayOption option;
  final bool checked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: checked ? AppColors.primary : const Color(0xFFE0E0E0),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              // ICON bulat gradient + PNG
              Container(
                width: 48,
                height: 48,

                alignment: Alignment.center,
                child: Image.asset(option.iconPath, width: 48, height: 48),
              ),
              const SizedBox(width: 14),

              Expanded(
                child: Text(
                  option.title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),

              // Check bulat kanan
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color:
                        checked ? AppColors.primary : const Color(0xFFD9D9D9),
                    width: 2,
                  ),
                  color: checked ? AppColors.primary : Colors.transparent,
                ),
                child:
                    checked
                        ? const Icon(Icons.check, size: 18, color: Colors.white)
                        : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DayOption {
  final String title;
  final String iconPath;
  const _DayOption(this.title, this.iconPath);
}
