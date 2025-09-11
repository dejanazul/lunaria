import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lunaria/constants/colors.dart';
import 'package:lunaria/providers/signup_data_provider.dart';
import 'package:lunaria/widgets/auth/auth_components.dart';
import 'package:provider/provider.dart';

import '../profile/my_profile_typical_day_page.dart';

class MyProfileActivitiesPage extends StatefulWidget {
  const MyProfileActivitiesPage({super.key});

  @override
  State<MyProfileActivitiesPage> createState() =>
      _MyProfileActivitiesPageState();
}

class _MyProfileActivitiesPageState extends State<MyProfileActivitiesPage> {
  /// Data activities (nama + path ikon PNG)
  final List<_Activity> activities = const [
    _Activity('Yoga', 'assets/icons/activities/yoga.png'),
    _Activity('Dance', 'assets/icons/activities/dance.png'),
    _Activity('Aerobik', 'assets/icons/activities/aerobik.png'),
    _Activity('Zumba', 'assets/icons/activities/zumba.png'),
    _Activity('HIIT', 'assets/icons/activities/hiit.png'),
    _Activity('Pilates', 'assets/icons/activities/pilates.png'),
    _Activity('Workout', 'assets/icons/activities/workout.png'),
  ];

  final Set<String> _selected = {}; // simpan nama activity yang dipilih

  void _toggle(String name) {
    setState(() {
      if (_selected.contains(name)) {
        _selected.remove(name);
      } else {
        _selected.add(name);
      }
    });
  }

  void _saveActivities() {
    if (_selected.isEmpty) return;

    final signupProvider = Provider.of<SignupDataProvider>(
      context,
      listen: false,
    );
    signupProvider.updatePreferredActivities(_selected.toList());

    // Debug print the data
    signupProvider.debugPrintData();

    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => MyProfileTypicalDayPage()));
  }

  @override
  Widget build(BuildContext context) {
    final canNext = _selected.length >= 3;

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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                "Choose up to 3 activities\nyou’re interested in",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                itemCount: activities.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, i) {
                  final a = activities[i];
                  final checked = _selected.contains(a.name);
                  final reachLimit = _selected.length >= 10 && !checked;

                  return _ActivityTile(
                    activity: a,
                    checked: checked,
                    disabled: reachLimit,
                    onTap: () => _toggle(a.name),
                  );
                },
              ),
            ),

            SafeArea(
              top: false,
              minimum: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              child:
                  canNext
                      ? GradientButton(
                        text: 'Next',
                        onTap: _saveActivities,

                        // print(_selected.toList());
                      )
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

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({
    required this.activity,
    required this.checked,
    required this.onTap,
    this.disabled = false,
  });

  final _Activity activity;
  final bool checked;
  final bool disabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: disabled ? null : onTap,
      borderRadius: BorderRadius.circular(14),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),

          border: Border.all(
            color: checked ? AppColors.primary : const Color(0xFFE0E0E0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,

                alignment: Alignment.center,
                child: Image.asset(
                  activity.iconPath,
                  width: 48,
                  height: 48,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 14),

              Expanded(
                child: Text(
                  activity.name,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: disabled ? const Color(0xFF9E9E9E) : Colors.black,
                  ),
                ),
              ),

              _CircleCheck(checked: checked, disabled: disabled),
            ],
          ),
        ),
      ),
    );
  }
}

class _CircleCheck extends StatelessWidget {
  const _CircleCheck({required this.checked, this.disabled = false});
  final bool checked;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final Color borderColor =
        disabled
            ? const Color(0xFFE0E0E0)
            : (checked ? AppColors.primary : const Color(0xFFD9D9D9));

    final Color fill =
        disabled
            ? Colors.transparent
            : (checked ? AppColors.primary : Colors.transparent);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 2),
        color: fill,
      ),
      child:
          checked
              ? const Icon(Icons.check, size: 18, color: Colors.white)
              : null,
    );
  }
}

class _Activity {
  final String name;
  final String iconPath;
  const _Activity(this.name, this.iconPath);
}
