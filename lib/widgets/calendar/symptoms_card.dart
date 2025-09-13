import 'package:flutter/material.dart';
import 'package:lunaria/widgets/calendar/white_card.dart';
import 'package:lunaria/widgets/calendar/header_with_button.dart';
import 'package:lunaria/screens/calendar/symptoms.dart';

class SymptomsCard extends StatelessWidget {
  final BuildContext parentContext;

  const SymptomsCard({super.key, required this.parentContext});

  @override
  Widget build(BuildContext context) {
    return WhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderWithButton(
            title: "Symptoms",
            buttonText: "Add +",
            onTap: () {
              showModalBottomSheet(
                context: parentContext,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const Symptoms(),
              );
            },
          ),
          const SizedBox(height: 8),
          const Text("How are you feeling today?"),
        ],
      ),
    );
  }
}
