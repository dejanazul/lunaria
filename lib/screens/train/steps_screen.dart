import 'package:flutter/material.dart';
import 'detail_artikel.dart';
import '../../services/news_api_service.dart';

class StepsScreen extends StatefulWidget {
  const StepsScreen({super.key});

  @override
  State<StepsScreen> createState() => _StepsScreenState();
}

class _StepsScreenState extends State<StepsScreen> {
  String _formatDate(DateTime date) {
    final weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return '${weekdays[date.weekday - 1]}, ${date.day.toString().padLeft(2, '0')} ${_monthName(date.month)}';
  }

  String _monthName(int month) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month];
  }

  String _getDayName(DateTime date) {
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return weekdays[date.weekday - 1];
  }

  int currentDayIndex = 0;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Set default ke hari ini jika ada di data, jika tidak ke data terakhir
    final today = DateTime.now();
    final idx = days.indexWhere(
      (d) =>
          d['date'].day == today.day &&
          d['date'].month == today.month &&
          d['date'].year == today.year,
    );
    if (idx != -1 && currentDayIndex != idx) {
      setState(() {
        currentDayIndex = idx;
      });
    } else if (idx == -1 && currentDayIndex != days.length - 1) {
      setState(() {
        currentDayIndex = days.length - 1;
      });
    }
  }

  final List<Map<String, dynamic>> days = [
    {
      'date': DateTime(2025, 8, 11),
      'steps': 1405,
      'goal': 5000,
      'distance': 1.12,
      'distanceGoal': 4.0,
      'calories': 60,
      'caloriesGoal': 250,
    },
    {
      'date': DateTime(2025, 8, 10),
      'steps': 3200,
      'goal': 5000,
      'distance': 2.5,
      'distanceGoal': 4.0,
      'calories': 120,
      'caloriesGoal': 250,
    },
    {
      'date': DateTime(2025, 8, 9),
      'steps': 5000,
      'goal': 5000,
      'distance': 4.0,
      'distanceGoal': 4.0,
      'calories': 250,
      'caloriesGoal': 250,
    },
  ];

  List<dynamic> articles = [];
  bool loadingArticles = true;

  @override
  void initState() {
    super.initState();
    fetchArticles();
  }

  Future<void> fetchArticles() async {
    // Use NewsApiService for walk/run/foot/step articles
    try {
      final fetched = await NewsApiService.fetchArticles(
        keywords: [
          'walk',
          'run',
          'foot',
          'feet',
          'steps',
          'walking',
          'running',
          'step',
        ],
        pageSize: 3,
      );
      setState(() {
        articles = (fetched as List).take(3).toList();
        loadingArticles = false;
      });
    } catch (e) {
      setState(() {
        loadingArticles = false;
      });
    }
  }

  void _showCalendarPopup() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _CalendarPopup(
          selectedDate: days[currentDayIndex]['date'],
          onDateSelected: (date) {
            // Optionally update currentDayIndex if date found
            final idx = days.indexWhere((d) => d['date'] == date);
            if (idx != -1) {
              setState(() {
                currentDayIndex = idx;
              });
            }
            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final day = days[currentDayIndex];
    final percent = (day['steps'] / day['goal']).clamp(0.0, 1.0);
    final selectedDate = day['date'] as DateTime;
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
          'Steps',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GestureDetector(
            onTap: _showCalendarPopup,
            child: Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left, size: 28),
                          onPressed:
                              currentDayIndex > 0
                                  ? () => setState(() => currentDayIndex--)
                                  : null,
                        ),
                        Column(
                          children: [
                            Text(
                              _getDayName(selectedDate),
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              _formatDate(selectedDate),
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right, size: 28),
                          onPressed:
                              currentDayIndex < days.length - 1
                                  ? () => setState(() => currentDayIndex++)
                                  : null,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _StepsProgressCircle(
                      percent: percent,
                      steps: day['steps'],
                      goal: day['goal'],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "You've taken the first step, but we know you've got more in you. Step out and reach your goal!",
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${day['distance'].toString().replaceAll('.', ',')} KM',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Distance',
                          style: TextStyle(fontFamily: 'Poppins', fontSize: 13),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Goal ${day['distanceGoal']}KM',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${day['calories']} KCAL',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Calories',
                          style: TextStyle(fontFamily: 'Poppins', fontSize: 13),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Goal ${day['caloriesGoal']}KCAL',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Steps Articles',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                ...(loadingArticles
                    ? [const Center(child: CircularProgressIndicator())]
                    : articles.isEmpty
                    ? [const Center(child: Text('No articles found.'))]
                    : articles.map((a) => _ArticleCard(article: a)).toList()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StepsProgressCircle extends StatelessWidget {
  final double percent;
  final int steps;
  final int goal;
  const _StepsProgressCircle({
    required this.percent,
    required this.steps,
    required this.goal,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 120,
            height: 120,
            child: CircularProgressIndicator(
              value: percent,
              strokeWidth: 10,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation(Color(0xFF913F9E)),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$steps',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              Text(
                'of $goal steps',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          Positioned(
            top: 12,
            child: Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                color: Color(0xFF913F9E),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ArticleCard extends StatelessWidget {
  final Map article;
  const _ArticleCard({required this.article});

  @override
  Widget build(BuildContext context) {
    final hasImage =
        (article['urlToImage'] ?? article['imageUrl']) != null &&
        (article['urlToImage'] ?? article['imageUrl']).toString().isNotEmpty;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (_) => DetailArtikelScreen(
                    article: {
                      ...article,
                      'urlToImage':
                          article['urlToImage'] ?? article['imageUrl'],
                      'publishedAt': article['publishedAt'] ?? '',
                      'content': article['content'] ?? article['description'],
                      'description': article['description'],
                      'title': article['title'],
                    },
                  ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (hasImage)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    article['urlToImage'] ?? article['imageUrl'],
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (c, e, s) => Container(
                          width: 48,
                          height: 48,
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.image,
                            color: Colors.grey,
                            size: 24,
                          ),
                        ),
                  ),
                ),
              if (hasImage) const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article['title'] ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${article['readTime'] ?? '3 min'} read',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CalendarPopup extends StatelessWidget {
  final DateTime selectedDate;
  final void Function(DateTime) onDateSelected;
  const _CalendarPopup({
    required this.selectedDate,
    required this.onDateSelected,
  });

  String _monthName(int month) {
    const months = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month];
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateUtils.getDaysInMonth(
      selectedDate.year,
      selectedDate.month,
    );
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFFE7C6F7),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(28),
                topRight: Radius.circular(28),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Color(0xFF913F9E),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Text(
                  '${_monthName(selectedDate.month)} ${selectedDate.year}',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xFF913F9E),
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'M',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF913F9E),
                  ),
                ),
                Text(
                  'T',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF913F9E),
                  ),
                ),
                Text(
                  'W',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF913F9E),
                  ),
                ),
                Text(
                  'T',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF913F9E),
                  ),
                ),
                Text(
                  'F',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF913F9E),
                  ),
                ),
                Text(
                  'S',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF913F9E),
                  ),
                ),
                Text(
                  'S',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF913F9E),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1,
              ),
              itemCount: daysInMonth,
              itemBuilder: (context, idx) {
                final day = idx + 1;
                final date = DateTime(
                  selectedDate.year,
                  selectedDate.month,
                  day,
                );
                final isSelected = date.day == selectedDate.day;
                return GestureDetector(
                  onTap: () => onDateSelected(date),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF913F9E),
                        width: 2,
                      ),
                      color:
                          isSelected
                              ? const Color(0xFF913F9E).withOpacity(0.15)
                              : Colors.transparent,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '$day',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        color:
                            isSelected ? const Color(0xFF913F9E) : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
