import 'package:flutter/material.dart';

class RemindersPage extends StatefulWidget {
  const RemindersPage({super.key});

  @override
  State<RemindersPage> createState() => _RemindersPageState();
}

class _RemindersPageState extends State<RemindersPage> {
  bool allowReminders = true;
  bool remindExercise = false;
  bool upcomingPeriod = true;
  bool cycleInsights = true;

  Widget buildSwitchTile(String title, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(title, style: const TextStyle(fontSize: 14)),
      value: value,
      onChanged: onChanged,
      activeColor: const Color(0xFF7B2CBF),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget buildSectionCard(List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Card(
        color: Colors.white,
        margin: EdgeInsets.zero,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: children,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Reminders",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          // GLOBAL
          buildSectionTitle("GLOBAL"),
          buildSectionCard([
            buildSwitchTile("Allow reminders", allowReminders, (val) {
              setState(() => allowReminders = val);
            }),
          ]),

          // WORKOUTS
          buildSectionTitle("WORKOUTS"),
          buildSectionCard([
            buildSwitchTile("Remind me to exercise", remindExercise, (val) {
              setState(() => remindExercise = val);
            }),
          ]),

          // CYCLE TRACKING
          buildSectionTitle("CYCLE TRACKING"),
          buildSectionCard([
            buildSwitchTile("Upcoming Period", upcomingPeriod, (val) {
              setState(() => upcomingPeriod = val);
            }),
            const Divider(height: 1, indent: 16, endIndent: 16),
            buildSwitchTile("Cycle Insights", cycleInsights, (val) {
              setState(() => cycleInsights = val);
            }),
          ]),
        ],
      ),
    );
  }
}
