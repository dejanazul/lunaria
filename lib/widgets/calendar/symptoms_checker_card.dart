import 'package:flutter/material.dart';
import 'package:lunaria/constants/colors.dart';
import 'package:lunaria/screens/calendar/symptomschecker.dart';
import 'package:lunaria/widgets/calendar/white_card.dart';
import 'package:lunaria/widgets/calendar/header_with_button.dart';

class SymptomsCheckerCard extends StatelessWidget {
  final BuildContext parentContext;

  const SymptomsCheckerCard({super.key, required this.parentContext});

  @override
  Widget build(BuildContext context) {
    return WhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderWithButton(
            title: "Symptoms Checker",
            buttonText: "Check",
            onTap: () {
              showModalBottomSheet(
                context: parentContext,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const Symptomschecker(),
              );
            },
          ),
          const SizedBox(height: 8),
          const Text("Check your symptoms"),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5), // Light grey color
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/pet_illustration.png',
                  width: 30,
                  height: 30,
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    "I can help you understand your symptoms 😊",
                    style: TextStyle(color: AppColors.secondary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
