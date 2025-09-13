import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lunaria/routes/navigation_service.dart';
import 'package:lunaria/widgets/bottom_nav.dart';
import 'package:lunaria/helpers/responsive_helper.dart';
import 'package:lunaria/widgets/calendar/index.dart';
import 'logactivity.dart';
import 'detailcalendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDate = DateTime.now();

  String get _monthYear => DateFormat.yMMMM().format(
    DateTime(_focusedDate.year, _focusedDate.month),
  );

  Future<void> _pickMonthYear() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _focusedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: "Select Month & Year",
    );
    if (picked != null) {
      setState(() {
        _focusedDate = picked;
      });
    }
  }

  List<DateTime> _getWeekDates(DateTime base) {
    final startOfWeek = base.subtract(Duration(days: base.weekday % 7));
    return List.generate(7, (i) => startOfWeek.add(Duration(days: i)));
  }

  @override
  Widget build(BuildContext context) {
    final int currentIndex = 0;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom + 120,
              ),
              child: Column(
                children: [
                  // 🔹 Header Calendar
                  Container(
                    padding: EdgeInsets.only(
                      top: ResponsiveHelper.isTablet(context) ? 50 : 40,
                      left: ResponsiveHelper.isTablet(context) ? 24 : 16,
                      right: ResponsiveHelper.isTablet(context) ? 24 : 16,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.pink.shade300, Colors.pink.shade200],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(
                          ResponsiveHelper.isTablet(context) ? 50 : 40,
                        ),
                        bottomRight: Radius.circular(
                          ResponsiveHelper.isTablet(context) ? 50 : 40,
                        ),
                      ),
                    ),
                    child: SizedBox(
                      height: ResponsiveHelper.isTablet(context) ? 375 : 325,
                      child: Column(
                        children: [
                          // Top bar
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const Logactivity(),
                                    ),
                                  );
                                },
                              ),
                              GestureDetector(
                                onTap: _pickMonthYear,
                                child: Text(
                                  _monthYear,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: ResponsiveHelper.getFontSize(
                                      context,
                                      small: 16,
                                      medium: 18,
                                      large: 20,
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.calendar_today,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const DetailCalendar(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          // 🔹 Mini Calendar
                          SizedBox(
                            height:
                                ResponsiveHelper.isTablet(context) ? 100 : 80,
                            child: PageView.builder(
                              controller: PageController(initialPage: 5000),
                              onPageChanged: (index) {
                                setState(() {
                                  _focusedDate = DateTime.now().add(
                                    Duration(days: (index - 5000) * 7),
                                  );
                                });
                              },
                              itemBuilder: (context, index) {
                                final baseDate = DateTime.now().add(
                                  Duration(days: (index - 5000) * 7),
                                );
                                final weekDates = _getWeekDates(baseDate);

                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children:
                                      weekDates.map((date) {
                                        bool isToday = DateUtils.isSameDay(
                                          date,
                                          DateTime.now(),
                                        );
                                        return _DateItem(
                                          label: DateFormat('E').format(date),
                                          day: date.day.toString(),
                                          isToday: isToday,
                                        );
                                      }).toList(),
                                );
                              },
                            ),
                          ),

                          const SizedBox(height: 24),

                          // 🔹 Period Info
                          Text(
                            "Period",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: ResponsiveHelper.getFontSize(
                                context,
                                small: 14,
                                medium: 16,
                                large: 18,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: ResponsiveHelper.isMobile(context) ? 4 : 6,
                          ),
                          Text(
                            "Day 1",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: ResponsiveHelper.getFontSize(
                                context,
                                small: 32,
                                medium: 36,
                                large: 40,
                              ),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height:
                                ResponsiveHelper.isMobile(context) ? 16 : 20,
                          ),

                          // 🔹 Log Activity Button
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.pink,
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                    ResponsiveHelper.isTablet(context)
                                        ? 50
                                        : 40,
                                vertical:
                                    ResponsiveHelper.isTablet(context)
                                        ? 16
                                        : 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  ResponsiveHelper.isTablet(context) ? 28 : 24,
                                ),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const Logactivity(),
                                ),
                              );
                            },
                            child: Text(
                              "Log Activity",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: ResponsiveHelper.getFontSize(
                                  context,
                                  small: 14,
                                  medium: 15,
                                  large: 16,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height:
                                ResponsiveHelper.isTablet(context) ? 30 : 24,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 🔹 My Cycles Section
                  Padding(
                    padding: EdgeInsets.all(
                      ResponsiveHelper.isMobile(context)
                          ? 16
                          : (ResponsiveHelper.isTablet(context) ? 20 : 24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "My Cycles",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: ResponsiveHelper.getFontSize(
                              context,
                              small: 18,
                              medium: 20,
                              large: 24,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: ResponsiveHelper.isMobile(context) ? 16 : 20,
                        ),
                        _detailsCard(),
                        SizedBox(
                          height: ResponsiveHelper.isMobile(context) ? 16 : 20,
                        ),
                        _cycleHistoryCard(context),
                        SizedBox(
                          height: ResponsiveHelper.isMobile(context) ? 16 : 20,
                        ),
                        _symptomsCard(context),
                        SizedBox(
                          height: ResponsiveHelper.isMobile(context) ? 16 : 20,
                        ),
                        _symptomsCheckerCard(context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BottomNav(
              currentIndex: currentIndex,
              onTap: (index) {
                NavigationService.navigateToBottomNavScreen(
                  context,
                  index,
                  currentIndex,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Details Card
  Widget _detailsCard() {
    return const DetailsCard();
  }

  // 🔹 Cycle History Card
  Widget _cycleHistoryCard(BuildContext context) {
    return CycleHistoryCard(parentContext: context);
  }

  // 🔹 Symptoms Card (popup)
  Widget _symptomsCard(BuildContext context) {
    return SymptomsCard(parentContext: context);
  }

  // 🔹 Symptoms Checker Card (popup)
  Widget _symptomsCheckerCard(BuildContext context) {
    return SymptomsCheckerCard(parentContext: context);
  }
}

// ================= Helper Widgets ================= //

class _DateItem extends StatelessWidget {
  final String label;
  final String day;
  final bool isToday;

  const _DateItem({
    required this.label,
    required this.day,
    this.isToday = false,
  });

  @override
  Widget build(BuildContext context) {
    final double fontSize = ResponsiveHelper.getFontSize(
      context,
      small: 12,
      medium: 14,
      large: 16,
    );
    final double circlePadding = ResponsiveHelper.isTablet(context) ? 10 : 8;

    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: isToday ? Colors.pink : Colors.white,
            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
            fontSize: fontSize,
          ),
        ),
        SizedBox(height: ResponsiveHelper.isMobile(context) ? 4 : 6),
        Container(
          padding: EdgeInsets.all(circlePadding),
          decoration: BoxDecoration(
            color: isToday ? Colors.white : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Text(
            day,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isToday ? Colors.pink : Colors.white,
              fontSize: fontSize,
            ),
          ),
        ),
      ],
    );
  }
}
