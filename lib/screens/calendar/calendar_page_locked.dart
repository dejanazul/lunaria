import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lunaria/providers/calendar_ai_provider.dart';
import 'package:lunaria/providers/user_provider.dart';
import 'package:lunaria/routes/navigation_service.dart';
import 'package:lunaria/widgets/bottom_nav.dart';
import 'package:lunaria/helpers/responsive_helper.dart';
import 'package:lunaria/widgets/calendar/index.dart';
import 'package:provider/provider.dart';
import 'detailcalendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage>
    with SingleTickerProviderStateMixin {
  DateTime _focusedDate = DateTime.now();
  bool _isLocked =
      true; // Default locked, akan diupdate berdasarkan status provider
  bool _isAnalyzing = false;
  late AnimationController _animationController;
  late Animation<double> _lockAnimation;

  // Map untuk menyimpan warna fase berdasarkan tanggal
  final Map<DateTime, Color> _phaseColorMap = {};

  String get _monthYear => DateFormat.yMMMM().format(
    DateTime(_focusedDate.year, _focusedDate.month),
  );

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _lockAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutBack,
      ),
    );

    // Update phase colors when data is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Cek status analisis dari provider
      final calendarAiProvider = Provider.of<CalendarAiProvider>(
        context,
        listen: false,
      );
      if (calendarAiProvider.hasCompletedAnalysis) {
        // Jika sudah pernah melakukan analisis, buka kunci
        setState(() {
          _isLocked = false;
          // Jalankan animasi untuk membuka kunci
          _animationController.forward();
        });
      }

      _updatePhaseColors();
    });
  }

  // Metode untuk memperbarui peta warna fase berdasarkan data dari provider
  void _updatePhaseColors() {
    final calendarAiProvider = Provider.of<CalendarAiProvider>(
      context,
      listen: false,
    );
    if (calendarAiProvider.currentAnalysis != null) {
      final phases = calendarAiProvider.currentAnalysis!.periodPhase;
      _phaseColorMap.clear();

      for (final phase in phases) {
        final start = phase.startDate;
        final end = phase.endDate;
        final color = _getPhaseColor(phase.phaseName);

        // Isi semua tanggal dalam rentang dengan warna fase
        for (var i = 0; i <= end.difference(start).inDays; i++) {
          final date = DateTime(start.year, start.month, start.day + i);
          _phaseColorMap[date] = color;
        }
      }

      setState(() {});
    }
  }

  // Mendapatkan warna sesuai fase
  Color _getPhaseColor(String phaseName) {
    switch (phaseName.toLowerCase()) {
      case 'menstruasi':
        return const Color.fromARGB(255, 255, 17, 0);
      case 'folikular':
        return Colors.purple.shade200; // ungu muda
      case 'ovulasi':
        return Colors.purple.shade800; // ungu tua
      case 'luteal':
        return Colors.grey.shade400; // abu-abu
      default:
        return Colors.grey.shade300;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _analyzeWithAI() async {
    if (_isLocked && !_isAnalyzing) {
      setState(() {
        _isAnalyzing = true;
      });

      try {
        // Dapatkan user ID dari UserProvider
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        final calendarAiProvider = Provider.of<CalendarAiProvider>(
          context,
          listen: false,
        );

        final userId = userProvider.userId;

        if (userId != null) {
          // Gunakan instance CalendarAiProvider yang sudah dibuat
          final analysis = await calendarAiProvider.analyzeMenstrualCycle(
            userId,
          );

          // Tampilkan hasil analisis dalam dialog
          debugPrint('AI Analysis result: $analysis');

          // Update peta warna fase setelah mendapatkan analisis
          _updatePhaseColors();

          // Tunggu animasi kunci selesai baru tampilkan dialog
          await Future.delayed(const Duration(milliseconds: 800));
        } else {
          debugPrint('No user ID found. User might not be logged in.');
        }
      } catch (e) {
        debugPrint('Error during AI analysis: $e');

        // Tampilkan pesan kesalahan
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to analyze data: ${e.toString()}'),
              backgroundColor: Colors.red.shade400,
              behavior: SnackBarBehavior.floating,
              action: SnackBarAction(
                label: 'Dismiss',
                textColor: Colors.white,
                onPressed: () {},
              ),
            ),
          );
        }
      } finally {
        setState(() {
          _isAnalyzing = false;
          _isLocked = false;
        });

        // Jalankan animasi untuk membuka kunci
        _animationController.forward();
      }
    }
  }

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
    // Dengarkan perubahan pada provider untuk update warna fase dan status kunci
    final calendarAiProvider = Provider.of<CalendarAiProvider>(context);

    // Update status kunci berdasarkan hasCompletedAnalysis
    if (calendarAiProvider.hasCompletedAnalysis && _isLocked) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _isLocked = false;
          _animationController.forward();
        });
      });
    }

    if (calendarAiProvider.currentAnalysis != null) {
      // Update phase colors ketika analisis berubah
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _updatePhaseColors();
      });
    }

    final int currentIndex = 0;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          // Main content
          SingleChildScrollView(
            physics:
                _isLocked
                    ? const NeverScrollableScrollPhysics()
                    : const BouncingScrollPhysics(),
            child: Opacity(
              opacity: _isLocked ? 0.3 : 1.0,
              child: AbsorbPointer(
                absorbing: _isLocked,
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
                            colors: [
                              Colors.pink.shade300,
                              Colors.pink.shade200,
                            ],
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
                          height:
                              ResponsiveHelper.isTablet(context) ? 375 : 325,
                          child: Column(
                            children: [
                              // Top bar
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // IconButton(
                                  //   icon: const Icon(
                                  //     Icons.add,
                                  //     color: Colors.white,
                                  //   ),
                                  //   onPressed: () {
                                  //     Navigator.push(
                                  //       context,
                                  //       MaterialPageRoute(
                                  //         builder: (_) => const Logactivity(),
                                  //       ),
                                  //     );
                                  //   },
                                  // ),
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
                                  // IconButton(
                                  //   icon: const Icon(
                                  //     Icons.calendar_today,
                                  //     color: Colors.white,
                                  //   ),
                                  //   onPressed: () {
                                  //     Navigator.push(
                                  //       context,
                                  //       MaterialPageRoute(
                                  //         builder:
                                  //             (_) => const DetailCalendar(),
                                  //       ),
                                  //     );
                                  //   },
                                  // ),
                                ],
                              ),

                              const SizedBox(height: 17),

                              // 🔹 Mini Calendar
                              SizedBox(
                                height:
                                    ResponsiveHelper.isTablet(context)
                                        ? 100
                                        : 80,
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
                                            // Cek apakah tanggal ada dalam peta fase
                                            final normalizedDate = DateTime(
                                              date.year,
                                              date.month,
                                              date.day,
                                            );
                                            final phaseColor =
                                                _phaseColorMap[normalizedDate];

                                            return _DateItem(
                                              label: DateFormat(
                                                'E',
                                              ).format(date),
                                              day: date.day.toString(),
                                              isToday: isToday,
                                              phaseColor:
                                                  phaseColor, // Teruskan warna fase
                                            );
                                          }).toList(),
                                    );
                                  },
                                ),
                              ),

                              const SizedBox(height: 24),

                              // 🔹 Period Info
                              Consumer<CalendarAiProvider>(
                                builder: (context, provider, child) {
                                  // Dapatkan informasi fase saat ini
                                  final phaseInfo =
                                      provider.getCurrentPhaseInfo();
                                  final phaseName = phaseInfo['phaseName'];
                                  final phaseDay = phaseInfo['phaseDay'];

                                  // Format nama fase untuk tampilan
                                  String displayPhaseName = 'Unknown';
                                  if (phaseName != 'Unknown') {
                                    // Konversi nama fase ke bahasa Indonesia dengan kapitalisasi huruf pertama
                                    switch (phaseName.toLowerCase()) {
                                      case 'menstruasi':
                                        displayPhaseName = 'Menstruasi';
                                        break;
                                      case 'folikular':
                                        displayPhaseName = 'Folikular';
                                        break;
                                      case 'ovulasi':
                                        displayPhaseName = 'Ovulasi';
                                        break;
                                      case 'luteal':
                                        displayPhaseName = 'Luteal';
                                        break;
                                      default:
                                        // Kapitalisasi huruf pertama
                                        displayPhaseName =
                                            phaseName
                                                .substring(0, 1)
                                                .toUpperCase() +
                                            phaseName
                                                .substring(1)
                                                .toLowerCase();
                                    }
                                  }

                                  return Column(
                                    children: [
                                      Text(
                                        displayPhaseName,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize:
                                              ResponsiveHelper.getFontSize(
                                                context,
                                                small: 14,
                                                medium: 16,
                                                large: 18,
                                              ),
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            ResponsiveHelper.isMobile(context)
                                                ? 4
                                                : 6,
                                      ),
                                      Text(
                                        "Day ${phaseDay > 0 ? phaseDay.toString() : '?'}",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize:
                                              ResponsiveHelper.getFontSize(
                                                context,
                                                small: 32,
                                                medium: 36,
                                                large: 40,
                                              ),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                              SizedBox(
                                height:
                                    ResponsiveHelper.isMobile(context)
                                        ? 16
                                        : 20,
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
                                      ResponsiveHelper.isTablet(context)
                                          ? 28
                                          : 24,
                                    ),
                                  ),
                                  elevation: 0,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const DetailCalendar(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Log Period",
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
                                    ResponsiveHelper.isTablet(context)
                                        ? 30
                                        : 24,
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
                              height:
                                  ResponsiveHelper.isMobile(context) ? 16 : 20,
                            ),
                            _detailsCard(),
                            SizedBox(
                              height:
                                  ResponsiveHelper.isMobile(context) ? 16 : 20,
                            ),
                            _cycleHistoryCard(context),
                            SizedBox(
                              height:
                                  ResponsiveHelper.isMobile(context) ? 16 : 20,
                            ),
                            _symptomsCard(context),
                            SizedBox(
                              height:
                                  ResponsiveHelper.isMobile(context) ? 16 : 20,
                            ),
                            _symptomsCheckerCard(context),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Lock Overlay - shown when the calendar is locked
          if (_isLocked)
            Positioned.fill(
              child: Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24.0),
                  padding: const EdgeInsets.all(32.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Lock animation
                      AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: 1.0 + (_lockAnimation.value * 0.2),
                            child: Opacity(
                              opacity: 1.0 - _lockAnimation.value,
                              child: Icon(
                                _isLocked ? Icons.lock : Icons.lock_open,
                                size: 80,
                                color: Colors.pink.shade300,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      Text(
                        _isLocked
                            ? "Calendar Data Locked"
                            : "Calendar Unlocked!",
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getFontSize(
                            context,
                            small: 18,
                            medium: 20,
                            large: 24,
                          ),
                          fontWeight: FontWeight.bold,
                          color: Colors.pink.shade400,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _isLocked
                            ? "Analyze your cycle data to unlock calendar insights"
                            : "Your data is being processed",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getFontSize(
                            context,
                            small: 14,
                            medium: 16,
                            large: 18,
                          ),
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 32),
                      _isAnalyzing
                          ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.pink,
                            ),
                          )
                          : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pink.shade400,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: _analyzeWithAI,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(width: 8),
                                Text(
                                  "Analyze with AI",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: ResponsiveHelper.getFontSize(
                                      context,
                                      small: 14,
                                      medium: 16,
                                      large: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                    ],
                  ),
                ),
              ),
            ),

          // Bottom Nav
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
    final calendarAiProvider = Provider.of<CalendarAiProvider>(context);

    if (calendarAiProvider.currentAnalysis == null) {
      // Tampilkan placeholder atau data default
      return const DetailsCard(
        periodLength: "0",
        cycleLength: "0",
        cycleVariation: "0",
      );
    }

    return Consumer<CalendarAiProvider>(
      builder: (context, calendarAiProvider, child) {
        if (calendarAiProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (calendarAiProvider.currentAnalysis == null) {
          return const Center(child: Text("No analysis data available."));
        }

        return DetailsCard(
          periodLength:
              calendarAiProvider.currentAnalysis!.averagePeriodLength
                  .toString(),
          cycleLength:
              calendarAiProvider.currentAnalysis!.averageCycleLength.toString(),
          cycleVariation:
              calendarAiProvider.currentAnalysis!.averageCycleLength.toString(),
        );
      },
    );
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
  final Color? phaseColor; // Warna fase untuk tanggal ini

  const _DateItem({
    required this.label,
    required this.day,
    this.isToday = false,
    this.phaseColor,
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
            color: isToday ? const Color.fromARGB(255, 0, 0, 0) : Colors.white,
            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
            fontSize: fontSize,
          ),
        ),
        SizedBox(height: ResponsiveHelper.isMobile(context) ? 4 : 6),
        Container(
          padding: EdgeInsets.all(circlePadding),
          decoration: BoxDecoration(
            // Gunakan phaseColor jika tersedia, jika tidak gunakan warna default
            color:
                phaseColor != null
                    ? phaseColor!.withOpacity(0.8)
                    : (isToday ? Colors.white : Colors.transparent),
            shape: BoxShape.circle,
            // Tambahkan border untuk hari dengan fase
            border:
                phaseColor != null
                    ? Border.all(color: phaseColor!, width: 2)
                    : null,
          ),
          child: Text(
            day,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              // Sesuaikan warna teks berdasarkan latar belakang
              color:
                  isToday
                      ? const Color.fromARGB(255, 0, 0, 0)
                      : (phaseColor != null ? Colors.white : Colors.white),
              fontSize: fontSize,
            ),
          ),
        ),
      ],
    );
  }
}
