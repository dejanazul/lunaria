import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CreatingPlanPage extends StatefulWidget {
  /// Halaman tujuan setelah selesai (100%)
  final Widget nextPage;

  /// Durasi total animasi menuju 100%
  final Duration totalDuration;

  const CreatingPlanPage({
    super.key,
    required this.nextPage,
    this.totalDuration = const Duration(seconds: 5),
  });

  @override
  State<CreatingPlanPage> createState() => _CreatingPlanPageState();
}

class _CreatingPlanPageState extends State<CreatingPlanPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _anim;
  Timer? _fakeWork; // opsional kalau mau ada “step” tiap detik

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.totalDuration,
    );

    _anim = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    // Saat selesai, navigasi ke halaman berikutnya
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // jeda 400ms agar angka 100% terlihat
        Future.delayed(const Duration(milliseconds: 400), () {
          if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => widget.nextPage),
            );
          }
        });
      }
    });

    // Mulai animasi
    _controller.forward();

    // Opsional: simulasi “tugas” tiap detik (mis. untuk centang animasi)
    _fakeWork = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {}); // memicu rebuild agar checklist bisa “aktif bertahap”
    });
  }

  @override
  void dispose() {
    _fakeWork?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = GoogleFonts.interTextTheme(theme.textTheme);

    // Checklist yang akan dicentang bertahap seiring waktu
    final steps = const [
      'Analyzing your profile',
      'Estimating your metabolic age',
      'Adapting the plan to your busy schedule',
      'Selecting suitable workouts & recipes',
    ];

    // Hitung berapa item yang dianggap "selesai" berdasarkan progres
    final progress = _anim.value; // 0..1
    final completedCount = (progress * (steps.length + 0.999)).floor().clamp(
      0,
      steps.length,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _anim,
          builder: (context, _) {
            final percent = (progress * 100).round();

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 12),
                  // Progress circle + angka
                  SizedBox(
                    height: 220,
                    width: 220,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Lingkaran background
                        SizedBox(
                          height: 220,
                          width: 220,
                          child: CircularProgressIndicator(
                            value: 1,
                            strokeWidth: 12,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.black12,
                            ),
                          ),
                        ),
                        // Progres berwarna
                        SizedBox(
                          height: 220,
                          width: 220,
                          child: CircularProgressIndicator(
                            value: progress == 0 ? 0.001 : progress,
                            strokeWidth: 12,
                            // Ungu lembut seperti mockup
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFFB36AE2),
                            ),
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                        // Persentase
                        Text(
                          '$percent%',
                          style: textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Creating Your Plan',
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Checklist
                  Expanded(
                    child: ListView.separated(
                      itemCount: steps.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final done = index < completedCount;
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Icon bulat hitam dengan centang putih
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle,
                                // Sedikit transparan sebelum “done”
                                // (terlihat aktif bertahap)
                                // ignore: dead_code
                                // done ? Colors.black : Colors.black.withOpacity(0.25),
                              ),
                              child: Icon(
                                Icons.check_rounded,
                                size: 18,
                                color: done
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.35),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                steps[index],
                                style: textTheme.bodyLarge?.copyWith(
                                  color: Colors.black87,
                                  fontWeight: done
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  // Bottom indicator (garis iOS)
                  Container(
                    margin: const EdgeInsets.only(bottom: 6, top: 6),
                    height: 4,
                    width: 140,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
