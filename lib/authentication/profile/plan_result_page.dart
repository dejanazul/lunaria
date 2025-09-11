// lib/features/plan/plan_result_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lunaria/providers/signup_data_provider.dart';
import 'package:lunaria/screens/home_pet/vp_home.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;

/// Simple point class for chart
class Point {
  final double x;
  final double y;

  const Point(this.x, this.y);
}

/// Custom painter for line chart
class LineChartPainter extends CustomPainter {
  final List<Point> spots;
  final double minX, maxX, minY, maxY;

  LineChartPainter({
    required this.spots,
    required this.minX,
    required this.maxX,
    required this.minY,
    required this.maxY,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw grid lines
    final gridPaint =
        Paint()
          ..color = Colors.black12
          ..strokeWidth = 1;

    // Vertical grid lines
    for (int i = 1; i <= 4; i++) {
      final x = _getXPosition(i.toDouble(), size.width);
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    // Horizontal grid lines
    for (int i = 0; i <= 4; i++) {
      final y = _getYPosition(i.toDouble(), size.height);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Draw line
    if (spots.length > 1) {
      final linePaint =
          Paint()
            ..shader = ui.Gradient.linear(
              Offset(
                _getXPosition(spots.first.x, size.width),
                _getYPosition(spots.first.y, size.height),
              ),
              Offset(
                _getXPosition(spots.last.x, size.width),
                _getYPosition(spots.last.y, size.height),
              ),
              [Colors.red, Colors.orange, Colors.green],
              [0.1, 0.5, 0.9],
            )
            ..strokeWidth = 5
            ..strokeCap = StrokeCap.round
            ..style = PaintingStyle.stroke;

      final path = Path();
      path.moveTo(
        _getXPosition(spots.first.x, size.width),
        _getYPosition(spots.first.y, size.height),
      );

      for (int i = 1; i < spots.length; i++) {
        // Add smooth curve
        final prevPoint = spots[i - 1];
        final currentPoint = spots[i];

        final controlPointX1 = _getXPosition(
          prevPoint.x + (currentPoint.x - prevPoint.x) / 2,
          size.width,
        );
        final controlPointY1 = _getYPosition(prevPoint.y, size.height);
        final controlPointX2 = _getXPosition(
          prevPoint.x + (currentPoint.x - prevPoint.x) / 2,
          size.width,
        );
        final controlPointY2 = _getYPosition(currentPoint.y, size.height);

        path.cubicTo(
          controlPointX1,
          controlPointY1,
          controlPointX2,
          controlPointY2,
          _getXPosition(currentPoint.x, size.width),
          _getYPosition(currentPoint.y, size.height),
        );
      }

      canvas.drawPath(path, linePaint);

      // Draw dots
      final dotPaint =
          Paint()
            ..color = Colors.white
            ..strokeWidth = 2
            ..style = PaintingStyle.fill;

      final dotStrokePaint =
          Paint()
            ..color = Colors.green
            ..strokeWidth = 2
            ..style = PaintingStyle.stroke;

      for (final spot in spots) {
        final x = _getXPosition(spot.x, size.width);
        final y = _getYPosition(spot.y, size.height);

        canvas.drawCircle(Offset(x, y), 6, dotPaint);
        canvas.drawCircle(Offset(x, y), 6, dotStrokePaint);
      }
    }
  }

  double _getXPosition(double x, double width) {
    return (x - minX) / (maxX - minX) * width;
  }

  double _getYPosition(double y, double height) {
    return height - (y - minY) / (maxY - minY) * height;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class PlanResultPage extends StatefulWidget {
  const PlanResultPage({super.key});

  @override
  State<PlanResultPage> createState() => _PlanResultPageState();
}

class _PlanResultPageState extends State<PlanResultPage> {
  bool _showReward = false;
  bool _claimed = false;

  void _onGetMyPlan() async {
    setState(() => _showReward = true);

    // Get user data from SignupDataProvider
    final signupData = Provider.of<SignupDataProvider>(context, listen: false);

    try {
      // Calculate BMI if height and weight are available
      double? calculatedBmi;
      if (signupData.height != null && signupData.weight != null) {
        final heightInMeters = signupData.height! / 100; // Convert cm to m
        calculatedBmi = signupData.weight! / (heightInMeters * heightInMeters);
        calculatedBmi = double.parse(
          calculatedBmi.toStringAsFixed(2),
        ); // Round to 2 decimal places
      }

      // Since this is part of the signup process, we should create the user account
      // using the completeSignUp method

      // Make sure we have the required fields for signup
      if (signupData.username == null ||
          signupData.email == null ||
          signupData.password == null) {
        debugPrint('❌ Missing required fields for signup');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Missing required signup information'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Complete the signup process with all collected user data
      final success = await signupData.completeSignUp(
        username: signupData.username!,
        email: signupData.email!,
        password: signupData.password!,
        name: signupData.name,
        birthDate: signupData.birthDate,
        lastCycle: signupData.startDate,
        cycleDuration: signupData.periodLength,
        lifestyle: signupData.lifestyle, // Use lifestyle information
        preferredActivities: signupData.preferredActivities,
        bmi: calculatedBmi,
      );

      if (success) {
        debugPrint(
          '✅ User account created successfully and all profile data saved to Supabase',
        );

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        debugPrint('❌ Failed to create user account');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to create account: ${signupData.errorMessage}',
            ),
            backgroundColor: Colors.red,
          ),
        );
        return; // Don't proceed to home screen if account creation failed
      }
    } catch (e) {
      debugPrint('❌ Error during account creation: $e');
      // Show error to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
      return; // Don't proceed to home screen if an error occurred
    }
  }

  void _onClaim() {
    setState(() {
      _claimed = true;
      _showReward = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = GoogleFonts.interTextTheme(Theme.of(context).textTheme);
    final signupDataProvider = Provider.of<SignupDataProvider>(
      context,
      listen: false,
    );

    final pageBody = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          Consumer<SignupDataProvider>(
            builder: (context, signupData, _) {
              final username = signupData.name ?? 'User';
              return Text(
                '$username, your\npersonalized plan is\nready!',
                textAlign: TextAlign.center,
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              );
            },
          ),
          const SizedBox(height: 32),

          const _InfoRow(title: 'Duration', value: '4 weeks'),
          const SizedBox(height: 12),
          const _InfoRow(title: 'Goal', value: 'Healthy lifestyle'),
          const SizedBox(height: 12),
          _InfoRow(
            title: 'Interests',
            value:
                signupDataProvider.preferredActivities?.join(', ') ?? "Not set",
          ),
          const SizedBox(height: 32),

          // ===== Chart (versi sederhana) =====
          Expanded(
            child: _ProgressChart(
              minX: 1,
              maxX: 4,
              minY: 0,
              maxY: 4,
              spots: [
                Point(1, 3.5),
                Point(2, 2.8),
                Point(3, 1.5),
                Point(4, 0.8),
              ],
              leftLabel: 'Now',
              rightLabel: 'After 4 weeks',
            ),
          ),

          const SizedBox(height: 32),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: const Color(0xFF6A1B9A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              onPressed: _onGetMyPlan,
              child: Text(
                _claimed ? 'PLAN READY' : 'GET MY PLAN',
                style: textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Stack(
          children: [
            pageBody,

            // ===== Overlay Reward (muncul di page yang sama) =====
            if (_showReward) ...[
              // backdrop
              Positioned.fill(
                child: GestureDetector(
                  onTap:
                      () => setState(() {
                        _showReward = false;
                      }),
                  child: Container(color: Colors.black.withOpacity(0.25)),
                ),
              ),
              // popup
              Center(
                child: _RewardPopup(
                  onClaim: _onClaim,
                  // menggunakan asset cookie yang tersedia
                  cookieAssetPath: 'assets/images/cookie_icon.png',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _RewardPopup extends StatefulWidget {
  final VoidCallback onClaim;
  final String? cookieAssetPath;

  const _RewardPopup({required this.onClaim, this.cookieAssetPath});

  @override
  State<_RewardPopup> createState() => _RewardPopupState();
}

class _RewardPopupState extends State<_RewardPopup>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 220),
  )..forward();
  late final Animation<double> _scale = CurvedAnimation(
    parent: _c,
    curve: Curves.easeOutBack,
  );

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = GoogleFonts.interTextTheme(Theme.of(context).textTheme);
    return ScaleTransition(
      scale: _scale,
      child: Container(
        width: 300,
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 16,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.35,
                ),
                children: const [
                  TextSpan(
                    text: 'Awesome! ',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  TextSpan(
                    text:
                        'Your response has been saved. 10 cookies are waiting — claim them now!',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _CookieImage(assetPath: widget.cookieAssetPath),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: const Color(0xFF6A1B9A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                ),
                onPressed: () {
                  widget.onClaim;
                  if (mounted) {
                    widget.onClaim();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const VPHomeScreen()),
                    );
                  }
                },
                child: Text(
                  'CLAIM',
                  style: t.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CookieImage extends StatelessWidget {
  final String? assetPath;
  const _CookieImage({this.assetPath});

  @override
  Widget build(BuildContext context) {
    if (assetPath != null) {
      return Image.asset(assetPath!, height: 72, fit: BoxFit.contain);
    }
    // fallback jika asset belum ada
    return const Icon(Icons.cookie_outlined, size: 72, color: Colors.brown);
  }
}

class _InfoRow extends StatelessWidget {
  final String title;
  final String value;
  const _InfoRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    final textTheme = GoogleFonts.interTextTheme(Theme.of(context).textTheme);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFEAEAEA),
          ),
          child: const Icon(Icons.laptop, size: 20, color: Colors.black54),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Chart sederhana tanpa fl_chart untuk menghindari masalah kompatibilitas
class _ProgressChart extends StatelessWidget {
  final List<Point> spots;
  final double minX, maxX, minY, maxY;
  final String leftLabel, rightLabel;

  const _ProgressChart({
    required this.spots,
    required this.minX,
    required this.maxX,
    required this.minY,
    required this.maxY,
    required this.leftLabel,
    required this.rightLabel,
  });

  @override
  Widget build(BuildContext context) {
    const contentPadding = EdgeInsets.fromLTRB(18, 18, 18, 22);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      padding: contentPadding,
      child: Column(
        children: [
          Expanded(
            child: CustomPaint(
              painter: LineChartPainter(
                spots: spots,
                minX: minX,
                maxX: maxX,
                minY: minY,
                maxY: maxY,
              ),
              size: Size.infinite,
            ),
          ),
          // Bottom labels
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (int i = 1; i <= 4; i++)
                  Text(
                    'W$i',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Now and After 4 weeks
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                leftLabel,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                rightLabel,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
