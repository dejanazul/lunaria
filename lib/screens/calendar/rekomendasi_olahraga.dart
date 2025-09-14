import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cookie_provider.dart';
import '../../widgets/cookie_counter.dart';
import '../train/video_detail_screen.dart';
import '../train/video_list_screen.dart';
import '../../services/youtube_video_service.dart';

class RekomendasiOlahragaScreen extends StatefulWidget {
  final List<String> symptoms;

  const RekomendasiOlahragaScreen({super.key, required this.symptoms});

  @override
  State<RekomendasiOlahragaScreen> createState() =>
      _RekomendasiOlahragaScreenState();
}

class _RekomendasiOlahragaScreenState extends State<RekomendasiOlahragaScreen> {
  List<Map<String, dynamic>> videos = [];
  bool isLoading = true;
  String tag = "yoga"; // Default tag for video search

  @override
  void initState() {
    super.initState();
    _fetchRecommendedVideos();
  }

  Future<void> _fetchRecommendedVideos() async {
    // Determine the best tag based on symptoms
    _determineVideoTag();

    // Fetch videos with the determined tag
    final fetched = await YoutubeVideoService.fetchVideosByTag(tag);

    if (mounted) {
      setState(() {
        videos = fetched;
        isLoading = false;
      });
    }
  }

  void _determineVideoTag() {
    // Logic to determine the best tag based on symptoms
    if (widget.symptoms.contains("Backache") ||
        widget.symptoms.contains("Back pain")) {
      tag = "yoga back pain";
    } else if (widget.symptoms.contains("Tender breasts")) {
      tag = "gentle yoga";
    } else if (widget.symptoms.contains("Mood swings") ||
        widget.symptoms.contains("Irritability")) {
      tag = "meditation yoga";
    } else if (widget.symptoms.contains("Headache") ||
        widget.symptoms.contains("Migraine")) {
      tag = "yoga headache relief";
    } else if (widget.symptoms.contains("Bloating") ||
        widget.symptoms.contains("Cramps")) {
      tag = "yoga menstrual cramps";
    } else {
      tag = "gentle yoga"; // Default tag
    }
  }

  String _getSymptomsDescription() {
    if (widget.symptoms.isEmpty) {
      return "Based on your cycle, gentle yoga can help you feel more comfortable and balanced during this time.";
    }

    final joinedSymptoms = widget.symptoms.join(", ");
    return "You've logged ${joinedSymptoms.toLowerCase()}. Gentle yoga can help ease the discomfort, relax your body, and improve your overall well-being. Taking a few minutes each day for light stretches may make you feel more comfortable and balanced. We've prepared a recommended exercise video below, feel free to follow along and give your body the care it needs. And here's a little motivation: once you finish your workout, you'll earn a cookie as a sweet reward! 🍪";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      appBar: AppBar(
        backgroundColor: const Color(0xF7F7F7F7),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Move to Relieve',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Poppins',
            fontSize: 23,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Consumer<CookieProvider>(
              builder:
                  (context, cookieProvider, _) =>
                      CookieCounter(count: cookieProvider.cookies),
            ),
          ),
        ],
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Symptoms Section
                    _buildSymptomsCard(),
                    const SizedBox(height: 15),

                    // Video Recommendation Section
                    _buildVideoRecommendationCard(),
                  ],
                ),
              ),
    );
  }

  Widget _buildSymptomsCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 5,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Symptoms',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const Divider(color: Color(0xFFE4E4E4), thickness: 0.5, height: 24),
            Text(
              _getSymptomsDescription(),
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: Color(0xFF8E8E8E),
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoRecommendationCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 5,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Video Recommendation',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to video list screen with the appropriate tag
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoListScreen(tag: tag),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF913F9E),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'See All',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(color: Color(0xFFE4E4E4), thickness: 0.5, height: 24),
            if (videos.isNotEmpty) _buildFeaturedVideo(videos[0]),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedVideo(Map<String, dynamic> video) {
    final cookieProvider = Provider.of<CookieProvider>(context, listen: false);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => VideoDetailScreen(
                  video: video,
                  onComplete: () {
                    // Add cookies when video is completed
                    cookieProvider.addCookies(10);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('+10 cookies!')),
                    );
                  },
                ),
          ),
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              video['thumbnail'],
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 7),

          // Video details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  video['title'],
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  'Lunaria | 30K views',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF8E8E8E),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  video['description'] ??
                      'Start your day with this gentle yoga flow designed to help ease discomfort and improve your overall wellbeing. In just a few minutes, you\'ll stretch out stiffness, boost your energy, and find more comfort.',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF8E8E8E),
                    height: 1.6,
                  ),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
