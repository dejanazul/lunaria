import 'package:flutter/material.dart';
import '../../helpers/responsive_helper.dart';
import '../../widgets/bottom_nav.dart';
import '../../routes/routes.dart';
import '../../constants/app_colors.dart';

class TrainScreen extends StatefulWidget {
  const TrainScreen({super.key});

  @override
  State<TrainScreen> createState() => _TrainScreenState();
}

class _TrainScreenState extends State<TrainScreen>
    with SingleTickerProviderStateMixin {
  final int _currentIndex = 1;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(height: 16),
              TabBar(
                controller: _tabController,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Color(0xFF913F9E),
                indicatorWeight: 5,
                labelStyle: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: ResponsiveHelper.getSubheadingFontSize(context),
                ),
                tabs: const [Tab(text: 'Exercise'), Tab(text: 'Trainer')],
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Moving Time Bar Chart
                _movingTimeBarChart(),
                SizedBox(height: 24),
                // Steps & Time Asleep dalam satu row
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _summaryItem(
                          title: 'Steps',
                          value: '17',
                          goal: 'Goal 5.000',
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: _summaryItem(
                          title: 'Time Asleep',
                          value: '--',
                          goal: 'Goal 8h 0min',
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                // Section berikutnya akan diimplementasikan bertahap...
              ],
            ),
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

  Widget _summaryItem({
    required String title,
    required String value,
    required String goal,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontFamily: 'Poppins',
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        SizedBox(height: 4),
        Text(
          goal,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }

  Widget _movingTimeBarChart() {
    final List<Map<String, dynamic>> data = [
      {"day": "TUE", "percent": 0.7},
      {"day": "WED", "percent": 0.8},
      {"day": "THU", "percent": 0.6},
      {"day": "FRI", "percent": 0.9},
      {"day": "SAT", "percent": 1.0},
      {"day": "SUN", "percent": 0.85},
      {"day": "TODAY", "percent": 0.3},
    ];
    double progress = 0.25; // 25% progress
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Judul dan progress
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Moving Time',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '0/20 min',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
              // Circular progress bar dengan ikon barbel
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 5,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF913F9E),
                      ),
                    ),
                  ),
                  // Ganti dengan Image.asset jika ada ikon barbel di assets/icons/barbell.svg/png
                  Icon(
                    Icons.fitness_center,
                    color: Color(0xFF913F9E),
                    size: 22,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 24),
          // Bar chart
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children:
                  data.map((item) {
                    final isToday = item["day"] == "TODAY";
                    final double percent = item["percent"] as double;
                    final double barHeight = 100.0;
                    final double filledHeight = barHeight * percent;
                    final double emptyHeight = barHeight - filledHeight;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: 12,
                            height: barHeight,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // Abu-abu di atas
                                Container(
                                  height: emptyHeight,
                                  width: 12,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(6),
                                    ),
                                  ),
                                ),
                                // Ungu di bawah
                                Container(
                                  height: filledHeight,
                                  width: 12,
                                  decoration: BoxDecoration(
                                    color:
                                        isToday
                                            ? Colors.grey[300]
                                            : Color(0xFF913F9E),
                                    borderRadius: BorderRadius.vertical(
                                      bottom: Radius.circular(6),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            item["day"],
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Weekly Average",
                style: TextStyle(color: Colors.grey, fontFamily: 'Poppins'),
              ),
              Text(
                "18 min",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
