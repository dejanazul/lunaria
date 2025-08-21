import 'package:flutter/material.dart';
import '../../components/bottom_nav.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            _buildHeader(),
            // Scrollable Body
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 25),
                      // My Cycles Title
                      const Text(
                        'My Cycles',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          height: 0.8,
                          color: Color(0xFF000000),
                        ),
                      ),
                      const SizedBox(height: 31),
                      // Details Section
                      _buildDetailsSection(),
                      const SizedBox(height: 15),
                      // Cycle History Section
                      _buildCycleHistorySection(),
                      const SizedBox(height: 15),
                      // Symptoms Section
                      _buildSymptomsSection(),
                      const SizedBox(height: 15),
                      // Symptoms Checker Section
                      _buildSymptomsCheckerSection(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      height: 351,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFC6FA1), Color(0xFFFFA7C7), Color(0xFFFFE5EE)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(67),
          bottomRight: Radius.circular(67),
        ),
      ),
      child: Stack(
        children: [
          // Top Section with Calendar Icon and Month
          Positioned(
            top: 48,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(
                  Icons.add_circle_outline,
                  size: 24,
                  color: Colors.black,
                ),
                const Text(
                  'August 2025',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    height: 1.25,
                    letterSpacing: -0.5,
                    color: Colors.black,
                  ),
                ),
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 24,
                  color: Colors.black,
                ),
              ],
            ),
          ),
          // Weekly Calendar
          Positioned(top: 93, left: 27, child: _buildWeeklyCalendar()),
          // Period Info
          Positioned(
            top: 179,
            left: 143,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Period',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    height: 1.0,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Day 1',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 40,
                    height: 0.4,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          // Log Activity Button
          Positioned(
            top: 278,
            left: 137,
            child: Container(
              width: 116,
              height: 34,
              decoration: BoxDecoration(
                color: const Color(0xFF913F9E),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    offset: const Offset(1, 2),
                    blurRadius: 5,
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  'Log Activity',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    height: 1.43,
                    letterSpacing: -0.5,
                    color: Color(0xFFFF5893),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyCalendar() {
    return Row(
      children: [
        _buildCalendarDay('Fri', '8', false),
        const SizedBox(width: 30),
        _buildCalendarDay('Sat', '9', false),
        const SizedBox(width: 30),
        _buildCalendarDay('Sun', '10', false),
        const SizedBox(width: 30),
        _buildCalendarDay('Today', '11', true),
        const SizedBox(width: 30),
        _buildCalendarDay('Tue', '12', false),
        const SizedBox(width: 30),
        _buildCalendarDay('Wed', '13', false),
        const SizedBox(width: 30),
        _buildCalendarDay('Thu', '14', false),
      ],
    );
  }

  Widget _buildCalendarDay(String dayName, String dayNumber, bool isToday) {
    return Column(
      children: [
        Text(
          dayName,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
            fontSize: 11,
            height: 1.82,
            letterSpacing: -0.5,
            color: isToday ? const Color(0xFF252F4A) : const Color(0xFF808080),
          ),
        ),
        const SizedBox(height: 8),
        if (isToday)
          Container(
            width: 26,
            height: 26,
            decoration: const BoxDecoration(
              color: Color(0xFFFD699D),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                dayNumber,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  height: 1.43,
                  letterSpacing: -0.5,
                  color: Colors.white,
                ),
              ),
            ),
          )
        else
          Text(
            dayNumber,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              fontSize: 14,
              height: 1.43,
              letterSpacing: -0.5,
              color: Color(0xFF484C52),
            ),
          ),
      ],
    );
  }

  Widget _buildDetailsSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            offset: const Offset(2, 2),
            blurRadius: 5,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(9),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Details',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 15,
                height: 1.07,
                color: Color(0xFF000000),
              ),
            ),
            const SizedBox(height: 27),
            _buildDetailsDivider(),
            const SizedBox(height: 10),
            _buildDetailsRow('6 Days', 'Previous Period Length', 'NORMAL'),
            const SizedBox(height: 43),
            _buildDetailsDivider(),
            const SizedBox(height: 10),
            _buildDetailsRow('33 Days', 'Previous Cycle Length', 'NORMAL'),
            const SizedBox(height: 43),
            _buildDetailsDivider(),
            const SizedBox(height: 10),
            _buildDetailsRow('27-33 Days', 'Cycle Length Variation', 'NORMAL'),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsRow(String value, String label, String status) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  fontSize: 10,
                  height: 1.6,
                  color: Color(0xFF8E8E8E),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                  height: 1.07,
                  color: Color(0xFF000000),
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            const Icon(Icons.check_circle, size: 10, color: Color(0xFF1FC01F)),
            const SizedBox(width: 5),
            Text(
              status,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                fontSize: 10,
                height: 1.6,
                color: Color(0xFF000000),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailsDivider() {
    return Container(
      width: double.infinity,
      height: 0.5,
      color: const Color(0xFFE4E4E4),
    );
  }

  Widget _buildCycleHistorySection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            offset: const Offset(2, 2),
            blurRadius: 5,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(9),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Cycle History',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    height: 1.07,
                    color: Color(0xFF000000),
                  ),
                ),
                _buildSeeAllButton(),
              ],
            ),
            const SizedBox(height: 27),
            _buildDetailsDivider(),
            const SizedBox(height: 10),
            _buildCycleHistoryRow('Started Aug 11', 'Current Cycle: 1 Day'),
            const SizedBox(height: 54),
            _buildDetailsDivider(),
            const SizedBox(height: 10),
            _buildCycleHistoryRowWithArrow('Jul 9 - Aug 10', '33 Days'),
            const SizedBox(height: 48),
            _buildDetailsDivider(),
            const SizedBox(height: 10),
            _buildCycleHistoryRowWithArrow('Jun 10 - Jul 8', '29 Days'),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildCycleHistoryRow(String subtitle, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          subtitle,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
            fontSize: 10,
            height: 1.6,
            color: Color(0xFF8E8E8E),
          ),
        ),
        const SizedBox(height: 3),
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
            fontSize: 15,
            height: 1.07,
            color: Color(0xFF000000),
          ),
        ),
      ],
    );
  }

  Widget _buildCycleHistoryRowWithArrow(String subtitle, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subtitle,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                fontSize: 10,
                height: 1.6,
                color: Color(0xFF8E8E8E),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                fontSize: 15,
                height: 1.07,
                color: Color(0xFF000000),
              ),
            ),
          ],
        ),
        const Icon(Icons.arrow_forward_ios, size: 12, color: Color(0xFF8E8E8E)),
      ],
    );
  }

  Widget _buildSymptomsSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            offset: const Offset(2, 2),
            blurRadius: 5,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(9),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Symptoms',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    height: 1.07,
                    color: Color(0xFF000000),
                  ),
                ),
                _buildAddButton(),
              ],
            ),
            const SizedBox(height: 27),
            _buildDetailsDivider(),
            const SizedBox(height: 41),
            const Text(
              'How are you feeling today?',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                fontSize: 15,
                height: 1.07,
                color: Color(0xFF000000),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Logging daily symptoms helps you track your\nhealth over time.',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                fontSize: 10,
                height: 1.6,
                color: Color(0xFF8E8E8E),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSymptomsCheckerSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            offset: const Offset(2, 2),
            blurRadius: 5,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(9),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Symptoms Checker',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    height: 1.07,
                    color: Color(0xFF000000),
                  ),
                ),
                _buildSeeAllButton(),
              ],
            ),
            const SizedBox(height: 27),
            _buildDetailsDivider(),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 14,
                  height: 12,
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFCC00),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'We detected at least one symptom\nthat may need your attention.',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                          height: 1.07,
                          color: Color(0xFF000000),
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'View the full report to explore possible causes of your\nsymptoms, understand their impact, and discover\nrecommended steps to help you feel better.',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: 10,
                          height: 1.6,
                          color: Color(0xFF8E8E8E),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSeeAllButton() {
    return Container(
      width: 57,
      height: 22,
      decoration: BoxDecoration(
        color: const Color(0xFF913F9E),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            offset: const Offset(1, 2),
            blurRadius: 5,
          ),
        ],
      ),
      child: const Center(
        child: Text(
          'See All',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            fontSize: 10,
            height: 2.0,
            letterSpacing: -0.5,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return Container(
      width: 57,
      height: 22,
      decoration: BoxDecoration(
        color: const Color(0xFF913F9E),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            offset: const Offset(1, 2),
            blurRadius: 5,
          ),
        ],
      ),
      child: const Center(
        child: Text(
          'Add +',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            fontSize: 10,
            height: 2.0,
            letterSpacing: -0.5,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
