import 'package:flutter/material.dart';

class Symptoms extends StatefulWidget {
  const Symptoms({super.key});

  @override
  State<Symptoms> createState() => _SymptomsState();
}

class _SymptomsState extends State<Symptoms> {
  final Map<String, bool> _selected = {}; // simpan semua pilihan chip

  Widget _buildCategory(String title, List<Widget> chips) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Wrap(spacing: 8, runSpacing: 8, children: chips),
          ],
        ),
      ),
    );
  }

  Widget _chip(String emoji, String text, {Color? color}) {
    String key = "$emoji$text";
    bool isSelected = _selected[key] ?? false;

    return FilterChip(
      label: Text("$emoji $text"),
      selected: isSelected,
      onSelected: (val) {
        setState(() {
          _selected[key] = val;
        });
      },
      selectedColor: (color ?? Colors.purple.shade50).withOpacity(0.9),
      backgroundColor: (color ?? Colors.purple.shade50).withOpacity(0.6),
      checkmarkColor: Colors.black54,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.95,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, controller) => Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // 🔹 Header Cancel / Save
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.purple,
                      fontSize: 18, // ✅ Dibuat lebih besar
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Text(
                  "Symptoms",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, _selected); // return hasil
                  },
                  child: const Text(
                    "Save",
                    style: TextStyle(
                      color: Colors.purple,
                      fontSize: 18, // ✅ Dibuat lebih besar
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // 🔹 Body (scrollable)
            Expanded(
              child: ListView(
                controller: controller,
                children: [
                  // 🔹 Search
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: "Search",
                        border: InputBorder.none,
                        icon: Icon(Icons.search),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  const Text("Categories",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black)),

                  // 🔹 Mood
                  _buildCategory("Mood", [
                    _chip("😊", "Happy"),
                    _chip("⚡", "Energetic"),
                    _chip("🔥", "Frisky"),
                    _chip("😌", "Calm"),
                    _chip("😵‍💫", "Mood Swings"),
                    _chip("😠", "Irritated"),
                    _chip("😢", "Sad"),
                    _chip("😟", "Anxious"),
                    _chip("😞", "Depressed"),
                    _chip("😔", "Feeling Guilty"),
                    _chip("❓", "Confused"),
                    _chip("🔄", "Obsessive Thoughts"),
                    _chip("😐", "Apathetic"),
                    _chip("💤", "Low Energy"),
                    _chip("🤯", "Very Self-critical"),
                  ]),

                  // 🔹 Symptoms
                  _buildCategory("Symptoms", [
                    _chip("😃", "Everything Is Fine"),
                    _chip("🤕", "Cramps"),
                    _chip("🤱", "Tender Breasts"),
                    _chip("🤯", "Headache"),
                    _chip("😳", "Acne"),
                    _chip("💢", "Backache"),
                    _chip("🍫", "Cravings"),
                    _chip("😴", "Insomnia"),
                    _chip("😩", "Abdominal Pain"),
                    _chip("🥱", "Fatigue"),
                    _chip("😣", "Vaginal Itching"),
                    _chip("🥵", "Vaginal Dryness"),
                  ]),

                  // 🔹 Vaginal Discharge
                  _buildCategory("Vaginal Discharge", [
                    _chip("⭕", "No Discharge", color: Colors.orange.shade50),
                    _chip("🍦", "Creamy", color: Colors.orange.shade50),
                    _chip("💧", "Watery", color: Colors.orange.shade50),
                    _chip("🟠", "Sticky", color: Colors.orange.shade50),
                    _chip("🥚", "Egg White", color: Colors.orange.shade50),
                    _chip("🔴", "Spotting", color: Colors.orange.shade50),
                    _chip("❗", "Unusual", color: Colors.orange.shade50),
                    _chip("🤍", "Clumpy White", color: Colors.orange.shade50),
                    _chip("⚪", "Gray", color: Colors.orange.shade50),
                  ]),

                  // 🔹 Sex and Sex Drive
                  _buildCategory("Sex and Sex Drive", [
                    _chip("🙅‍♀️", "Didn't Have Sex", color: Colors.pink.shade50),
                    _chip("✅", "Protected Sex", color: Colors.pink.shade50),
                    _chip("❌", "Unprotected Sex", color: Colors.pink.shade50),
                    _chip("👄", "Oral Sex", color: Colors.pink.shade50),
                    _chip("🍑", "Anal Sex", color: Colors.pink.shade50),
                    _chip("✋", "Masturbation", color: Colors.pink.shade50),
                    _chip("🤗", "Sensual Touch", color: Colors.pink.shade50),
                    _chip("🧸", "Sex Toys", color: Colors.pink.shade50),
                    _chip("🔥", "High Sex Drive", color: Colors.pink.shade50),
                    _chip("😐", "Neutral Sex Drive", color: Colors.pink.shade50),
                    _chip("⬇️", "Low Sex Drive", color: Colors.pink.shade50),
                    _chip("💦", "Orgasm", color: Colors.pink.shade50),
                  ]),

                  // 🔹 Digestion and Stool
                  _buildCategory("Digestion and Stool", [
                    _chip("🤢", "Nausea", color: Colors.green.shade50),
                    _chip("🤰", "Bloating", color: Colors.green.shade50),
                    _chip("🚽", "Constipation", color: Colors.green.shade50),
                    _chip("💩", "Diarrhea", color: Colors.green.shade50),
                  ]),

                  // 🔹 Pregnancy Test
                  _buildCategory("Pregnancy Test", [
                    _chip("🟢", "Positive", color: Colors.teal.shade50),
                    _chip("💚", "Faint Line", color: Colors.teal.shade50),
                    _chip("❌", "Didn't Take Test", color: Colors.teal.shade50),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
