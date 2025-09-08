import 'package:flutter/material.dart';
import '../../helpers/responsive_helper.dart';
import '../../widgets/bottom_nav.dart';
import '../../routes/routes.dart';
import '../../constants/app_colors.dart';
import 'language.dart';
import 'reminder.dart';
import 'name.dart';
import 'birth.dart';
import 'height.dart';
import 'weight.dart';
import 'fitnesslvl.dart';
import 'classes.dart';
import 'dailystep.dart';
import 'termofuse.dart';
import 'privacypolicy.dart';
import 'subscriptionterm.dart';
import 'managepersonaldata.dart';
import 'eprivacy.dart';
import 'editprofile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final int _currentIndex = 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: ResponsiveHelper.getSubheadingFontSize(context),
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person_outline,
                size: ResponsiveHelper.getIconSize(context) * 3,
                color: Colors.white,
              ),
              SizedBox(height: ResponsiveHelper.getMediumSpacing(context)),
              Text(
                'Profile Screen',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: ResponsiveHelper.getHeadingFontSize(context) + 8,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: ResponsiveHelper.getSmallSpacing(context)),
              Text(
                'Manage your account\nand pet preferences',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: ResponsiveHelper.getBodyFontSize(context),
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          NavigationService.navigateToBottomNavScreen(
            context,
            index,
            _currentIndex,
          );
        },
      ),
    );
  }

  // Title Section
  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Wrapper Card
  Widget buildCard({required List<Widget> children}) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(children: children),
    );
  }

  // List Item
  Widget buildListTile(BuildContext context, String title, Widget page,
      {String? trailingText}) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontSize: 14)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null)
            Text(trailingText,
                style: const TextStyle(color: Colors.grey, fontSize: 13)),
          const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => page),
        );
      },
    );
  }
}