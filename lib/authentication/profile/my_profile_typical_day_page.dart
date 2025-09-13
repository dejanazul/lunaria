import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lunaria/constants/colors.dart';
import 'package:lunaria/providers/signup_data_provider.dart';
import 'package:lunaria/widgets/auth/auth_components.dart';
import 'package:provider/provider.dart';
import '../../helpers/responsive_helper.dart';
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
    final screenHeight = MediaQuery.of(context).size.height;

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
                      "What does your typical\nday look like?",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: ResponsiveHelper.getTitleFontSize(context),
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    // Adaptive spacing berdasarkan tinggi layar untuk mobile kecil
                    SizedBox(
                      height:
                          ResponsiveHelper.isSmallMobile(context)
                              ? (screenHeight < 700
                                  ? 80
                                  : 120) // Lebih kecil untuk layar pendek
                              : ResponsiveHelper.getAdaptiveSpacing(
                                context,
                                smallMobile: 150,
                                mobile: 220,
                                tablet: 280,
                              ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Options list dengan ukuran scrollable yang disesuaikan
          Expanded(
            child: Container(
              color: const Color(0xFFF5F5F5),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: ResponsiveHelper.getMaxContentWidth(context),
                    // Tinggi minimum untuk scrollable area pada mobile kecil
                    minHeight:
                        ResponsiveHelper.isSmallMobile(context) ? 300 : 350,
                  ),
                  child: Container(
                    // Memberi tinggi maksimal scrollable area
                    height:
                        ResponsiveHelper.isSmallMobile(context)
                            ? (screenHeight < 700
                                ? 280
                                : 320) // Disesuaikan dengan layar pendek
                            : null,
                    child: ListView.separated(
                      padding: EdgeInsets.symmetric(
                        horizontal:
                            ResponsiveHelper.getHorizontalPadding(
                              context,
                            ).horizontal /
                            2,
                        vertical: ResponsiveHelper.getSmallSpacing(context),
                      ),
                      itemCount: options.length,
                      separatorBuilder:
                          (_, __) => SizedBox(
                            height: ResponsiveHelper.getSmallSpacing(context),
                          ),
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
                            ? GradientButton(text: 'Next', onTap: _typicalDay)
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
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
                // ICON bulat gradient + PNG
                Container(
                  width: ResponsiveHelper.getIconSize(context) * 1.5,
                  height: ResponsiveHelper.getIconSize(context) * 1.5,
                  alignment: Alignment.center,
                  child: Image.asset(
                    option.iconPath,
                    width: ResponsiveHelper.getIconSize(context) * 1.5,
                    height: ResponsiveHelper.getIconSize(context) * 1.5,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(width: ResponsiveHelper.getMediumSpacing(context)),

                Expanded(
                  child: Text(
                    option.title,
                    style: GoogleFonts.poppins(
                      fontSize: ResponsiveHelper.getBodyFontSize(context),
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),

                // Check bulat kanan
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: ResponsiveHelper.getIconSize(context),
                  height: ResponsiveHelper.getIconSize(context),
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
                          ? Icon(
                            Icons.check,
                            size: ResponsiveHelper.getIconSize(context) * 0.6,
                            color: Colors.white,
                          )
                          : null,
                ),
              ],
            ),
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
