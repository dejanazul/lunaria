import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/level_provider.dart';

class LevelIndicator extends StatelessWidget {
  final VoidCallback? onTap;

  const LevelIndicator({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Consumer<LevelProvider>(
      builder: (context, levelProvider, _) {
        // Calculate progress percentage (0.0 to 1.0)
        double progressPercentage =
            levelProvider.currentXP / levelProvider.xpNeededForNextLevel;

        // Clamp to ensure it doesn't exceed 1.0
        progressPercentage = progressPercentage.clamp(0.0, 1.0);

        // Calculate width based on progress (max width is 109)
        double progressWidth = 109 * progressPercentage;

        return GestureDetector(
          onTap: () {
            // Increment XP when tapped
            levelProvider.addXP(10);

            // Call the provided onTap callback if available
            if (onTap != null) {
              onTap!();
            }
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
                      border: Border.all(color: const Color(0xFF913F9E)),
                    ),
                  ),
                ),
                // Level progress fill - width changes based on progress
                Positioned(
                  left: 11,
                  top: 4,
                  child: Container(
                    width: progressWidth.clamp(0, 109),
                    height: 25,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE9CBEE),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF913F9E)),
                    ),
                  ),
                ),
                // Level text
                Positioned(
                  left: 41,
                  top: 9,
                  child: Text(
                    'Level ${levelProvider.level}',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF901DA1),
                    ),
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
  }
}
