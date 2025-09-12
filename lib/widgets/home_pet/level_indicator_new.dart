import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/level_provider.dart';

class LevelIndicator extends StatefulWidget {
  const LevelIndicator({super.key});

  @override
  State<LevelIndicator> createState() => _LevelIndicatorState();
}

class _LevelIndicatorState extends State<LevelIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  int _previousXP = 0;
  int _previousLevel = 1;
  bool _showLevelUpEffect = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _progressAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    // Set initial values
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final levelProvider = Provider.of<LevelProvider>(context, listen: false);
      _previousXP = levelProvider.currentXP;
      _previousLevel = levelProvider.level;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showLevelUpNotification(BuildContext context, int level) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.emoji_events, color: Colors.amber),
            const SizedBox(width: 10),
            Text(
              'Selamat! anda sekarang level $level',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF913F9E),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height * 0.75,
          left: 20,
          right: 20,
        ),
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LevelProvider>(
      builder: (context, levelProvider, _) {
        // Check if XP or level changed
        if (_previousXP != levelProvider.currentXP ||
            _previousLevel != levelProvider.level) {
          // Show XP gained notification

          // Show level up effect if level increased
          if (_previousLevel < levelProvider.level) {
            _showLevelUpEffect = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showLevelUpNotification(context, levelProvider.level);
            });
          }

          // Update progress animation
          _animationController.reset();
          _progressAnimation = Tween<double>(
            begin:
                _previousXP /
                (_previousLevel == levelProvider.level
                    ? levelProvider.xpNeededForNextLevel
                    : 100),
            end: levelProvider.currentXP / levelProvider.xpNeededForNextLevel,
          ).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: Curves.easeOut,
            ),
          );
          _animationController.forward();

          // Save current values for next comparison
          _previousXP = levelProvider.currentXP;
          _previousLevel = levelProvider.level;
        }

        return AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            // Calculate progress percentage with animation
            double progressPercentage = _progressAnimation.value;
            progressPercentage = progressPercentage.clamp(0.0, 1.0);
            double progressWidth = 109 * progressPercentage;

            return GestureDetector(
              onTap: () {
                // Increment XP when tapped
                levelProvider.addXP(10);
              },
              child: SizedBox(
                width: 130,
                height: 45,
                child: Stack(
                  children: [
                    // Level progress background
                    Positioned(
                      left: 21,
                      top: 4,
                      child: Container(
                        width: 109,
                        height: 25,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFF913F9E),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    // Level progress fill - width changes based on progress
                    Positioned(
                      left: 21,
                      top: 4,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        width: progressWidth.clamp(0, 109),
                        height: 25,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE9CBEE),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFF913F9E),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    // Level text
                    Positioned(
                      left: 41,
                      top: 9,
                      child: Row(
                        children: [
                          Text(
                            'Level ${levelProvider.level}',
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF901DA1),
                            ),
                          ),
                          if (_showLevelUpEffect)
                            const Icon(
                              Icons.arrow_upward,
                              color: Color(0xFF901DA1),
                              size: 16,
                            ),
                        ],
                      ),
                    ),
                    // Level icon
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                        width: 42,
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: const DecorationImage(
                            image: AssetImage(
                              'assets/images/level_icon-13139c.png',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
