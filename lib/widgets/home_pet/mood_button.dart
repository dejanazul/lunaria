import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lunaria/providers/chat_history_provider.dart';
import 'package:provider/provider.dart';

class MoodButton extends StatelessWidget {
  const MoodButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatHistoryProvider>(
      builder: (context, chatProvider, child) {
        return GestureDetector(
          onTap: () {
            chatProvider.toggleCardVisibility();
          },
          child: SizedBox(
            width: 55,
            height: 55,
            child: Stack(
              children: [
                // Mood button background
                Container(
                  width: 55,
                  height: 55,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF420D4A), Color(0xFF7B347E)],
                    ),
                    shape: BoxShape.circle,
                  ),
                ),

                // Mood plus icon
                Center(
                  child: SvgPicture.asset(
                    "assets/icons/mood.svg",
                    width: 35,
                    height: 35,
                    colorFilter: ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
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
