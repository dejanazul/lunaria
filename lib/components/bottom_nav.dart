import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class BottomNav extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNav({super.key, required this.currentIndex, required this.onTap});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      decoration: const BoxDecoration(
        color: Color(0xFFF5F6F7),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Stack(
        children: [
          // Main bottom nav container
          Positioned(
            top: 18,
            left: 0,
            right: 0,
            child: Container(
              height: 56,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Calendar Tab
                    _buildNavItem(
                      index: 0,
                      icon: Icons.calendar_month,
                      label: 'Calendar',
                      isActive: widget.currentIndex == 0,
                    ),
                    // Train Tab
                    _buildNavItem(
                      index: 1,
                      icon: Icons.fitness_center,
                      label: 'Train',
                      isActive: widget.currentIndex == 1,
                    ),
                    // Spacer for center button
                    const SizedBox(width: 60),
                    // Community Tab
                    _buildNavItem(
                      index: 3,
                      icon: Icons.people_outline,
                      label: 'Community',
                      isActive: widget.currentIndex == 3,
                    ),
                    // Profile Tab
                    _buildNavItem(
                      index: 4,
                      icon: Icons.person_outline,
                      label: 'Profile',
                      isActive: widget.currentIndex == 4,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Center floating button
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Center(child: _buildCenterButton()),
          ),
          // Home Indicator
          Positioned(
            bottom: 21,
            left: 0,
            right: 0,
            child: Center(child: _buildHomeIndicator()),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
    required bool isActive,
  }) {
    return GestureDetector(
      onTap: () => widget.onTap(index),
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child:
                  isActive
                      ? ShaderMask(
                        shaderCallback:
                            (bounds) =>
                                AppColors.primaryGradient.createShader(bounds),
                        child: Icon(icon, size: 24, color: Colors.white),
                      )
                      : Icon(icon, size: 24, color: const Color(0xFF484C52)),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
                fontSize: 10,
                height: 1.2,
                color:
                    isActive
                        ? const Color(0xFF420D4A)
                        : const Color(0xFF484C52),
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterButton() {
    return GestureDetector(
      onTap: () => widget.onTap(2),
      child: Transform.translate(
        offset: const Offset(0, -18), // Move button up to overlap container
        child: Container(
          width: 63,
          height: 63,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 4),
          ),
          child: const Center(
            child: Icon(Icons.pets, size: 35, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildHomeIndicator() {
    return Container(
      width: 134,
      height: 5,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(100),
      ),
    );
  }
}
