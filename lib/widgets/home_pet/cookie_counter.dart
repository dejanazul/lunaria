import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cookie_provider.dart';

class CookieCounter extends StatefulWidget {
  final VoidCallback? onTap;

  const CookieCounter({super.key, this.onTap});

  @override
  State<CookieCounter> createState() => _CookieCounterState();
}

class _CookieCounterState extends State<CookieCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _showEffect = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _playAddAnimation() {
    setState(() {
      _showEffect = true;
    });
    _animationController.forward();
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() {
          _showEffect = false;
        });
      }
    });
  }

  void _showCookieAddedNotification(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/cookie_icon_new.png',
              width: 24,
              height: 24,
            ),
            const SizedBox(width: 8),
            const Text(
              'Cookie +1! Kumpulkan untuk memberi makan peliharaan!',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF553F35),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 80, left: 20, right: 20),
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CookieProvider>(
      builder: (context, cookieProvider, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Main Cookie Counter
            GestureDetector(
              onTap: () {
                cookieProvider.addCookies(1);
                _playAddAnimation();
                _showCookieAddedNotification(context);
                if (widget.onTap != null) {
                  widget.onTap!();
                }
              },
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _showEffect ? _scaleAnimation.value : 1.0,
                    child: child,
                  );
                },
                child: SizedBox(
                  width: 85,
                  height: 33,
                  child: Stack(
                    children: [
                      // Cookie counter background
                      Positioned(
                        left: 3,
                        top: 4,
                        child: Container(
                          width: 82,
                          height: 25,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2D6BA),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFF553F35),
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                      // Cookie count text
                      Positioned(
                        left: 39,
                        top: 9,
                        child: Text(
                          cookieProvider.cookies.toString(),
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF553F35),
                          ),
                        ),
                      ),
                      // Cookie icon
                      Positioned(
                        left: 0,
                        top: 0,
                        child: SizedBox(
                          width: 33,
                          height: 33,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.5),
                            child: Image.asset(
                              'assets/images/cookie_icon_new.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      // Shimmer effect when cookies added
                      if (_showEffect)
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withOpacity(0.0),
                                  Colors.white.withOpacity(0.3),
                                  Colors.white.withOpacity(0.0),
                                ],
                                stops: const [0.0, 0.5, 1.0],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
