import 'package:flutter/material.dart';
import 'steps_screen.dart';
import '../../helpers/responsive_helper.dart';
import '../../widgets/bottom_nav.dart';
import '../../routes/routes.dart';
import '../../routes/route_names.dart';
import './trainer_screen.dart';
import 'time_asleep.dart';
import '../../widgets/train/index.dart';

class TrainScreen extends StatefulWidget {
  const TrainScreen({super.key});

  @override
  State<TrainScreen> createState() => _TrainScreenState();
}

class _TrainScreenState extends State<TrainScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      bottomNavigationBar: BottomNav(
        currentIndex: 1, // Train tab index
        onTap: (index) {
          if (index != 1) {
            // Navigasi ke halaman sesuai dengan index bottom nav
            Navigator.pushReplacementNamed(
              context,
              index == 0
                  ? RouteNames.calendar
                  : index == 2
                  ? RouteNames.home
                  : index == 3
                  ? RouteNames.community
                  : RouteNames.profile,
            );
          }
        },
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey[100],
        automaticallyImplyLeading: false,
        flexibleSpace: SafeArea(
          child: TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: const Color(0xFF913F9E),
            indicatorWeight: 5,
            labelStyle: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              fontSize: ResponsiveHelper.getSubheadingFontSize(context),
            ),
            tabs: const [Tab(text: 'Exercise'), Tab(text: 'Trainer')],
            onTap: (index) {
              if (index == 1) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TrainerScreen(),
                  ),
                );
              }
            },
          ),
        ),
      ),
      body: SafeArea(
        bottom:
            false, // Karena bottomNavigationBar sudah memiliki padding sendiri
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width < 360 ? 12.0 : 20.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Moving Time Bar Chart
                const MovingTimeBarChart(),

                const SizedBox(height: 24),

                // Summary Items
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const StepsScreen(),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const SummaryItem(
                            title: 'Steps',
                            value: '3,785',
                            goal: 'Goal: 8,000 steps',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TimeAsleepScreen(),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const SummaryItem(
                            title: 'Time Asleep',
                            value: '6h 42m',
                            goal: 'Goal: 8 hours',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Sport Article Section
                const SportArticleSection(),

                // Padding bawah untuk menghindari konten tertutup oleh bottom nav
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
