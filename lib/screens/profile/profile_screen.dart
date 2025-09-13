import 'package:flutter/material.dart';
import 'package:lunaria/providers/user_provider.dart';
import 'package:lunaria/routes/navigation_service.dart';
import 'package:lunaria/services/auth_service.dart';
import 'package:lunaria/widgets/bottom_nav.dart';
import 'package:lunaria/widgets/profile/index.dart';
import 'package:lunaria/helpers/responsive_helper.dart';
import 'package:provider/provider.dart';
import 'language.dart';
import 'reminder.dart';
import 'name.dart';
import 'birth.dart';
import 'height.dart';
import 'weight.dart';
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
  bool trackCycle = false;
  final int _currentIndex = 4;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _refreshUserData();
  }

  // Fungsi untuk memperbarui data user dari database
  Future<void> _refreshUserData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final authService = AuthService();
      if (userProvider.user != null) {
        final updatedUser = await authService.getUserById(
          userProvider.user!.userId,
        );
        if (updatedUser != null) {
          userProvider.updateUserData(updatedUser);
        }
      }
    } catch (e) {
      print('Error refreshing user data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.grey[100],
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          Column(
            children: [
              // Header ungu sticky
              ProfileHeader(
                name: userProvider.user?.name ?? 'User',
                email: userProvider.user?.email ?? 'Email',
                username: userProvider.user?.username ?? 'Username',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EditProfilePage()),
                  ).then((_) => _refreshUserData()); // Refresh after edit
                },
              ),

              // Sisanya scroll
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(
                      bottom: ResponsiveHelper.isMobile(context) ? 130 : 160,
                      left: ResponsiveHelper.isMobile(context) ? 0 : 16,
                      right: ResponsiveHelper.isMobile(context) ? 0 : 16,
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: ResponsiveHelper.isMobile(context) ? 15 : 20,
                        ),

                        // General Section
                        SectionTitle(title: "General"),
                        ProfileCard(
                          children: [
                            ProfileListTile(
                              title: "Language",
                              page: const LanguagePage(),
                            ),
                            ProfileListTile(
                              title: "Reminders",
                              page: const RemindersPage(),
                            ),
                          ],
                        ),

                        SizedBox(
                          height: ResponsiveHelper.isMobile(context) ? 20 : 24,
                        ),

                        // Personal Details
                        SectionTitle(title: "Personal Details"),
                        ProfileCard(
                          children: [
                            ProfileListTile(
                              title: "Name",
                              page: const NamePage(),
                              trailingText:
                                  userProvider.user?.name ?? 'Not set',
                            ),
                            ProfileListTile(
                              title: "Date of Birth",
                              page: const BirthDatePage(),
                              trailingText:
                                  userProvider.user?.birthDate?.toString() ??
                                  'Not set',
                            ),
                            ProfileListTile(
                              title: "Height",
                              page: const HeightPage(),
                              trailingText:
                                  userProvider.user?.height != null
                                      ? "${userProvider.user!.height} cm"
                                      : 'Not set',
                            ),
                            ProfileListTile(
                              title: "Weight",
                              page: const WeightPage(),
                              trailingText:
                                  userProvider.user?.weight != null
                                      ? "${userProvider.user!.weight} kg"
                                      : 'Not set',
                            ),
                            ProfileListTile(
                              title: "Classes",
                              page: const ClassesPage(),
                              trailingText:
                                  userProvider.user?.preferredActivities != null
                                      ? userProvider.user!.preferredActivities!
                                          .join(", ")
                                      : 'Not set',
                            ),
                            ProfileListTile(
                              title: "Daily Step Goal",
                              page: const StepGoalPage(),
                              trailingText: "7.500",
                            ),
                            TrackCycleSwitch(
                              value: trackCycle,
                              onChanged: (val) {
                                setState(() {
                                  trackCycle = val;
                                });
                              },
                            ),
                          ],
                        ),

                        SizedBox(
                          height: ResponsiveHelper.isMobile(context) ? 20 : 24,
                        ),

                        // Legal & Privacy
                        SectionTitle(title: "Legal & Privacy"),
                        ProfileCard(
                          children: [
                            ProfileListTile(
                              title: "Terms of Use",
                              page: const TermsPage(),
                            ),
                            ProfileListTile(
                              title: "Privacy Policy",
                              page: const PrivacyPage(),
                            ),
                            ProfileListTile(
                              title: "Subscription Terms",
                              page: const SubscriptionPage(),
                            ),
                            ProfileListTile(
                              title: "Manage Personal Data",
                              page: const ManageDataPage(),
                            ),
                            ProfileListTile(
                              title: "e-Privacy Settings",
                              page: const EPrivacyPage(),
                            ),
                          ],
                        ),

                        SizedBox(
                          height: ResponsiveHelper.isMobile(context) ? 20 : 24,
                        ),

                        // Logout Section
                        ProfileCard(
                          children: [
                            LogoutButton(
                              onTap: () async {
                                await userProvider.signOut();
                                if (!context.mounted) return;

                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/login',
                                  (route) => false,
                                );
                              },
                            ),
                          ],
                        ),

                        SizedBox(
                          height: ResponsiveHelper.isMobile(context) ? 20 : 24,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BottomNav(
              currentIndex: _currentIndex,
              onTap: (index) {
                NavigationService.navigateToBottomNavScreen(
                  context,
                  index,
                  _currentIndex,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods sudah dipindahkan ke widget terpisah
}
