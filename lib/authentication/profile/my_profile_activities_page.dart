import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lunaria/constants/colors.dart';
import 'package:lunaria/providers/signup_data_provider.dart';
import 'package:lunaria/widgets/auth/auth_components.dart';
import 'package:provider/provider.dart';
import '../../helpers/responsive_helper.dart';

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
            fontSize: ResponsiveHelper.getHeadingFontSize(context),
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
            size: ResponsiveHelper.getIconSize(context) * 0.8,
          ),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: Color(0x11000000)),
        ),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Header section dengan background solid
          Container(
            width: double.infinity,
            color: const Color(0xFFF5F5F5),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal:
                      ResponsiveHelper.getHorizontalPadding(
                        context,
                      ).horizontal /
                      2,
                  vertical: ResponsiveHelper.getMediumSpacing(context),
                ),
                child: Column(
                  children: [
                    Text(
                      "Choose up to 3 activities\nyou're interested in",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: ResponsiveHelper.getTitleFontSize(context),
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: ResponsiveHelper.getMediumSpacing(context),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Activities list dengan proper z-index
          Expanded(
            child: Container(
              color: const Color(0xFFF5F5F5),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: ResponsiveHelper.getMaxContentWidth(context),
                  ),
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(
                      horizontal:
                          ResponsiveHelper.getHorizontalPadding(
                            context,
                          ).horizontal /
                          2,
                      vertical: ResponsiveHelper.getSmallSpacing(context),
                    ),
                    itemCount: activities.length,
                    separatorBuilder:
                        (_, __) => SizedBox(
                          height: ResponsiveHelper.getSmallSpacing(context),
                        ),
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
              ),
            ),
          ),

          // Bottom button dengan background solid dan shadow blocker
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFFF5F5F5),
              boxShadow: [
                BoxShadow(
                  color: Color(0x10000000),
                  offset: Offset(0, -2),
                  blurRadius: 8,
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal:
                      ResponsiveHelper.getHorizontalPadding(
                        context,
                      ).horizontal /
                      2,
                  vertical: ResponsiveHelper.getMediumSpacing(context),
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: ResponsiveHelper.getMaxContentWidth(context),
                    ),
                    child:
                        canNext
                            ? GradientButton(
                              text: 'Next',
                              onTap: _saveActivities,
                            )
                            : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black.withOpacity(0.4),
                                minimumSize: Size.fromHeight(
                                  ResponsiveHelper.getButtonHeight(context),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    ResponsiveHelper.getCardBorderRadius(
                                          context,
                                        ) *
                                        0.7,
                                  ),
                                ),
                                elevation: 4,
                                shadowColor: const Color(0x33000000),
                              ),
                              onPressed: null,
                              child: Text(
                                'Next',
                                style: GoogleFonts.poppins(
                                  fontSize:
                                      ResponsiveHelper.getSubheadingFontSize(
                                        context,
                                      ),
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black.withOpacity(0.4),
                                ),
                              ),
                            ),
                  ),
                ),
              ),
            ),
          ),
        ],
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: disabled ? null : onTap,
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getCardBorderRadius(context),
        ),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              ResponsiveHelper.getCardBorderRadius(context),
            ),
            border: Border.all(
              color: checked ? AppColors.primary : const Color(0xFFE0E0E0),
              width: checked ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0x08000000),
                offset: const Offset(0, 2),
                blurRadius: 8,
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.getMediumSpacing(context),
              vertical: ResponsiveHelper.getSmallSpacing(context) * 1.5,
            ),
            child: Row(
              children: [
                Container(
                  width: ResponsiveHelper.getIconSize(context) * 1.5,
                  height: ResponsiveHelper.getIconSize(context) * 1.5,
                  alignment: Alignment.center,
                  child: Image.asset(
                    activity.iconPath,
                    width: ResponsiveHelper.getIconSize(context) * 1.5,
                    height: ResponsiveHelper.getIconSize(context) * 1.5,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(width: ResponsiveHelper.getMediumSpacing(context)),

                Expanded(
                  child: Text(
                    activity.name,
                    style: GoogleFonts.poppins(
                      fontSize: ResponsiveHelper.getBodyFontSize(context),
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
      width: ResponsiveHelper.getIconSize(context),
      height: ResponsiveHelper.getIconSize(context),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 2),
        color: fill,
      ),
      child:
          checked
              ? Icon(
                Icons.check,
                size: ResponsiveHelper.getIconSize(context) * 0.6,
                color: Colors.white,
              )
              : null,
    );
  }
}

class _Activity {
  final String name;
  final String iconPath;
  const _Activity(this.name, this.iconPath);
}
