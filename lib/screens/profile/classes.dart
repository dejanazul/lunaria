import 'package:flutter/material.dart';

class ClassesPage extends StatefulWidget {
  const ClassesPage({super.key});

  @override
  State<ClassesPage> createState() => _ClassesPageState();
}

class _ClassesPageState extends State<ClassesPage> {
  final List<String> activities = [
    "Yoga",
    "Dance",
    "Aerobik",
    "Zumba",
    "HIIT",
    "Pilates",
    "Workout",
  ];

  final List<String> selected = [];

  void toggleSelection(String activity) {
    setState(() {
      if (selected.contains(activity)) {
        selected.remove(activity);
      } else {
        if (selected.length < 3) {
          selected.add(activity);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool canContinue = selected.isNotEmpty;

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
          "My Profile",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),
          const Text(
            "Choose up to 3 activities\nyou’re interested in",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),

          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: activities.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final activity = activities[index];
                final isSelected = selected.contains(activity);

                return GestureDetector(
                  onTap: () => toggleSelection(activity),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF6A1B9A)
                            : Colors.grey.shade300,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: const Color(0xFF6A1B9A),
                          radius: 20,
                          child: Text(
                            activity[0], // sementara pakai huruf depan
                            style: const TextStyle(
                                color: Colors.white, fontSize: 18),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            activity,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Icon(
                          isSelected
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color: isSelected
                              ? const Color(0xFF6A1B9A)
                              : Colors.grey,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Tombol Next
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24).copyWith(bottom: 24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: canContinue
                    ? () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                "Selected: ${selected.join(", ")}"),
                          ),
                        );
                        Navigator.pop(context, selected);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      canContinue ? const Color(0xFF6A1B9A) : Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 3,
                ),
                child: Text(
                  "Save",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: canContinue ? Colors.white : Colors.grey.shade500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
