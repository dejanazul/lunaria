import 'package:flutter/material.dart';
import '../../components/bottom_nav.dart';
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
  int _currentIndex = 4;

  bool trackCycle = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // Header ungu sticky
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EditProfilePage()),
              );
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40),
              decoration: const BoxDecoration(
                color: Color(0xFF7B2CBF),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person,
                        size: 50, color: Color(0xFF7B2CBF)),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Rizky Nabila Ramadhani",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "rizkynabilaramadhani@gmail.com",
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const Text(
                    "@rznabilar",
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),

          // Sisanya scroll
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // General Section
                  buildSectionTitle("General"),
                  buildCard(
                    children: [
                      buildListTile(context, "Language", const LanguagePage()),
                      buildListTile(context, "Reminders", const RemindersPage()),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Personal Details
                  buildSectionTitle("Personal Details"),
                  buildCard(
                    children: [
                      buildListTile(context, "Name", const NamePage(),
                          trailingText: "Nabila"),
                      buildListTile(context, "Date of Birth", const BirthDatePage(),
                          trailingText: "14 Nov 2003"),
                      buildListTile(context, "Height", const HeightPage(),
                          trailingText: "165 cm"),
                      buildListTile(context, "Weight", const WeightPage(),
                          trailingText: "57 kg"),
                      buildListTile(context, "Fitness Level", const FitnessLevelPage(),
                          trailingText: "Newbie"),
                      buildListTile(context, "Classes", const ClassesPage(),
                          trailingText: "Stretching, yoga"),
                      buildListTile(context, "Daily Step Goal", const StepGoalPage(),
                          trailingText: "7.500"),
                      SwitchListTile(
                        title: const Text("Track Cycle",
                            style: TextStyle(fontSize: 14)),
                        value: trackCycle,
                        onChanged: (val) {
                          setState(() {
                            trackCycle = val;
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Legal & Privacy
                  buildSectionTitle("Legal & Privacy"),
                  buildCard(
                    children: [
                      buildListTile(context, "Terms of Use", const TermsPage()),
                      buildListTile(context, "Privacy Policy", const PrivacyPage()),
                      buildListTile(
                          context, "Subscription Terms", const SubscriptionPage()),
                      buildListTile(
                          context, "Manage Personal Data", const ManageDataPage()),
                      buildListTile(
                          context, "e-Privacy Settings", const EPrivacyPage()),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Logout Section
                  buildCard(
                    children: [
                      ListTile(
                        title: const Text(
                          "Logout",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Logout tapped")),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),bottomNavigationBar: BottomNav(
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
