import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../providers/cookie_provider.dart';

class SetScheduleScreen extends StatefulWidget {
  const SetScheduleScreen({super.key});

  @override
  State<SetScheduleScreen> createState() => _SetScheduleScreenState();
}

class _SetScheduleScreenState extends State<SetScheduleScreen> {
  int selectedDay = 0;
  int bookingCost = 30;
  int? selectedSlot;

  final List<Map<String, String>> days = [
    {'day': 'Wed', 'date': '27 Aug'},
    {'day': 'Thu', 'date': '28 Aug'},
    {'day': 'Fri', 'date': '29 Aug'},
    {'day': 'Sat', 'date': '30 Aug'},
    {'day': 'Sun', 'date': '31 Aug'},
  ];

  final List<Map<String, String>> slots = [
    {'time': '06:00 - 07:00'},
    {'time': '07:00 - 08:00'},
    {'time': '08:00 - 09:00'},
    {'time': '09:00 - 10:00'},
    {'time': '10:00 - 11:00'},
    {'time': '11:00 - 12:00'},
    {'time': '13:00 - 14:00'},
    {'time': '14:00 - 15:00'},
    {'time': '15:00 - 16:00'},
  ];

  void _showPayDialog(int slotIdx) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Set Your Schedule',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Want to book? Just pay with\n30 cookies!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 15),
                ),
                SizedBox(height: 16),
                SvgPicture.asset(
                  'assets/icons/cookies_payment.svg',
                  width: 64,
                  height: 64,
                ),
                SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'PAY NOW',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      final cookieProvider = Provider.of<CookieProvider>(
                        context,
                        listen: false,
                      );
                      if (cookieProvider.spendCookies(bookingCost)) {
                        _showSuccessDialog(slotIdx);
                      } else {
                        _showErrorDialog();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSuccessDialog(int slotIdx) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Booking Confirmed!',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Your training session is scheduled for ${days[selectedDay]['date']} at ${slots[slotIdx]['time']!.split(' - ')[0]}. Get ready to start your day with energy!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 15),
                ),
                SizedBox(height: 16),
                SvgPicture.asset(
                  'assets/icons/finish_book.svg',
                  width: 64,
                  height: 64,
                ),
                SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'FINISH',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); // close dialog
                      Navigator.of(context).pop(); // close set_schedule.dart
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'cookies kamu kurang huhu',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Set Schedule',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Day selector
          Container(
            height: 60,
            color: Colors.transparent,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: days.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, idx) {
                final isSelected = idx == selectedDay;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDay = idx;
                    });
                  },
                  child: Container(
                    width: 64,
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? AppColors.primary.withOpacity(0.15)
                              : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color:
                            isSelected ? AppColors.primary : Colors.grey[300]!,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          days[idx]['day']!,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            color:
                                isSelected ? AppColors.primary : Colors.black,
                          ),
                        ),
                        Text(
                          days[idx]['date']!,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            color:
                                isSelected ? AppColors.primary : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: slots.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, idx) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Text(
                      slots[idx]['time']!,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: const Text(
                      '60 minute duration',
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 13),
                    ),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 8,
                        ),
                        textStyle: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text('Set Now'),
                      onPressed: () {
                        _showPayDialog(idx);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
