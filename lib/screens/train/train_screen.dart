import 'package:flutter/material.dart';
import 'steps_screen.dart';
import '../../helpers/responsive_helper.dart';
import '../../widgets/bottom_nav.dart';
import '../../routes/routes.dart';
import '../../routes/route_names.dart';
import './trainer_screen.dart';
import 'sport_articles.dart';
import '../../services/news_api_service.dart';
import 'detail_artikel.dart';
import 'time_asleep.dart';
import 'video_list_screen.dart';

// Import TrainerScreen
// Removed duplicate import of trainer_screen.dart

class TrainScreen extends StatefulWidget {
  const TrainScreen({super.key});

  @override
  State<TrainScreen> createState() => _TrainScreenState();
}

class _TrainScreenState extends State<TrainScreen>
    with SingleTickerProviderStateMixin {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  Icon(
                    Icons.fitness_center,
                    color: Color(0xFF913F9E),
                    size: 22,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8),
          Divider(color: Colors.grey[300], thickness: 1, height: 20),
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
                          SizedBox(
                            width: 12,
                            height: barHeight,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
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
          Divider(color: Colors.grey[300], thickness: 1, height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Weekly Average",
                style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'Poppins',
                  fontSize: 14,
                ),
              ),
              Text(
                "18 min",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sportArticleSection() {
    // --- SPORT ARTICLES SECTION UI & LOGIC ---
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: NewsApiService.fetchArticles(
        keywords: ['health', 'sport', 'exercise'],
        pageSize: 3,
      ),
      builder: (context, snapshot) {
        Widget content;
        if (snapshot.connectionState == ConnectionState.waiting) {
          content = const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          content = Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 40),
                  const SizedBox(height: 8),
                  Text(
                    'Gagal memuat berita terbaru.\n${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          final articles = snapshot.data ?? [];
          content = Column(
            children: [
              ...articles.map(
                (article) => InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailArtikelScreen(article: article),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          margin: const EdgeInsets.only(right: 12),
                          child:
                              (article['image'] != null &&
                                      article['image'].toString().isNotEmpty)
                                  ? Image.network(
                                    article['image'],
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (c, e, s) => Container(
                                          width: 60,
                                          height: 60,
                                          color: Colors.grey[300],
                                          child: const Icon(
                                            Icons.image,
                                            color: Colors.grey,
                                          ),
                                        ),
                                  )
                                  : Container(
                                    width: 60,
                                    height: 60,
                                    color: Colors.grey[300],
                                    child: const Icon(
                                      Icons.image,
                                      color: Colors.grey,
                                    ),
                                  ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                article['title'] ?? '',
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                article['publishedAt'] != null
                                    ? '${DateTime.tryParse(article['publishedAt'] ?? '')?.day ?? ''}/${DateTime.tryParse(article['publishedAt'] ?? '')?.month ?? ''}/${DateTime.tryParse(article['publishedAt'] ?? '')?.year ?? ''}'
                                    : '',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontFamily: 'Poppins',
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
            ],
          );
        }
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.only(bottom: 24),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Sport Articles',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SportArticlesScreen(),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF913F9E),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: Text(
                          'See All',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Stay informed with sport articles curated to match your interests. Each piece gives fresh insights, keeps you updated on the latest trends, and inspires you to embrace an active lifestyle at your own rhythm.',
                style: TextStyle(
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                  fontSize: 12,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 16),
              Divider(color: Colors.grey, thickness: 1, height: 20),
              content,
            ],
          ),
        );
      },
    );
  }

  late TabController _tabController;

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
                color: Colors.black,
                fontSize: 15,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
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
        // Divider khusus untuk Steps dan Time Asleep
        if (title == 'Steps' || title == 'Time Asleep') ...[
          SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Divider(
                  color: Colors.grey[300],
                  thickness: 1,
                  height: 20,
                ),
              ),
            ],
          ),
        ] else ...[
          SizedBox(height: 4),
        ],
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: Container(
          color: Colors.grey[100],
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
            ],
          ),
        ),
      ),
      body: SafeArea(
        bottom:
            false, // Karena bottomNavigationBar sudah memiliki padding sendiri
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _movingTimeBarChart(),
                SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const StepsScreen(),
                            ),
                          );
                        },
                        child: Container(
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
                          child: _summaryItem(
                            title: 'Steps',
                            value: '17',
                            goal: 'Goal 5.000',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const TimeAsleepScreen(),
                            ),
                          );
                        },
                        child: Container(
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
                          child: _summaryItem(
                            title: 'Time Asleep',
                            value: '--',
                            goal: 'Goal 8h 0min',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.only(bottom: 24),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Start Moving',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Start moving with guided workout videos designed for your needs. Each session helps ease discomfort, improve your health, and build lasting habits at your own pace.',
                        style: TextStyle(
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Colors.grey[300],
                              thickness: 1,
                              height: 5,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _SportIcon(
                                label: 'Yoga',
                                asset: 'assets/images/trainer_image_1.png',
                                tag: 'Yoga',
                              ),
                              _SportIcon(
                                label: 'Dance',
                                asset: 'assets/images/trainer_image_2.png',
                                tag: 'Dance',
                              ),
                              _SportIcon(
                                label: 'Aerobik',
                                asset: 'assets/images/trainer_image_3.png',
                                tag: 'Aerobics',
                              ),
                              _SportIcon(
                                label: 'Zumba',
                                asset: 'assets/images/trainer_image_4.png',
                                tag: 'Zumba',
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _SportIcon(
                                label: 'HIIT',
                                asset: 'assets/images/trainer_image_5.png',
                                tag: 'HIIT',
                              ),
                              _SportIcon(
                                label: 'Pilates',
                                asset: 'assets/images/trainer_image_6.png',
                                tag: 'Pilates',
                              ),
                              _SportIcon(
                                label: 'Workout',
                                asset: 'assets/images/trainer_image_7.png',
                                tag: 'Workout',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Sport Article Section
                _sportArticleSection(),

                // Padding bawah untuk menghindari konten tertutup oleh bottom nav
                SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // END of _TrainScreenState
}

// Widget for clickable sport icon (must be outside of _TrainScreenState)
class _SportIcon extends StatelessWidget {
  final String label;
  final String asset;
  final String tag;

  const _SportIcon({
    required this.label,
    required this.asset,
    required this.tag,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => VideoListScreen(tag: tag)),
        );
      },
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF913F9E), Color(0xFFB16CEA)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.asset(asset, fit: BoxFit.contain),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
