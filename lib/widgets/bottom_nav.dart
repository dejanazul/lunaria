import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
      height: 125,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 255, 255, 255),
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
                      svgAsset: 'assets/icons/calendar_outline.svg',
                      label: 'Calendar',
                      isActive: widget.currentIndex == 0,
                    ),
                    // Train Tab
                    _buildNavItem(
                      index: 1,
                      svgAsset: 'assets/icons/barbell.svg',
                      label: 'Train',
                      isActive: widget.currentIndex == 1,
                    ),
                    // Spacer for center button
                    const SizedBox(width: 60),
                    // Community Tab
                    _buildNavItem(
                      index: 3,
                      svgAsset: 'assets/icons/community.svg',
                      label: 'Community',
                      isActive: widget.currentIndex == 3,
                    ),
                    // Profile Tab
                    _buildNavItem(
                      index: 4,
                      svgAsset: 'assets/icons/person.svg',
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
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String svgAsset,
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
              height: 38,
              width: 38,
              child:
                  isActive
                      ? ShaderMask(
                        shaderCallback:
                            (bounds) =>
                                AppColors.primaryGradient.createShader(bounds),
                        blendMode: BlendMode.srcIn,
                        child: SvgPicture.asset(
                          svgAsset,
                          width: 24,
                          height: 24,
                          // Warnai putih agar gradient terlihat (mask berdasarkan alpha)
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                      )
                      : SvgPicture.asset(
                        svgAsset,
                        width: 24,
                        height: 24,
                        // Non-aktif: abu-abu
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF484C52),
                          BlendMode.srcIn,
                        ),
                      ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
                fontSize: 11,
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
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 4),
          ),
          child: Center(
            child: SvgPicture.asset(
              "assets/icons/paw.svg",
              width: 40,
              height: 32,
            ),
          ),
        ),
      ),
    );
  }
}
