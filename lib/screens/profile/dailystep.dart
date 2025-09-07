import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StepGoalPage extends StatefulWidget {
  const StepGoalPage({super.key});

  @override
  State<StepGoalPage> createState() => _StepGoalPageState();
}

class _StepGoalPageState extends State<StepGoalPage> {
  int? _selectedSteps; // null dulu
  final int _minSteps = 1000;
  final int _maxSteps = 20000;
  final int _stepInterval = 500; // interval langkah

  @override
  Widget build(BuildContext context) {
    final bool canSave = _selectedSteps != null;

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
          "Daily Step Goal",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),

          // Pertanyaan
          const Text(
            "What is your daily step goal?",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 32),

          // Placeholder atau hasil pilihan
          Text(
            _selectedSteps != null ? "${_selectedSteps!} steps" : "Type Here",
            style: TextStyle(
              fontSize: 22,
              fontWeight:
                  _selectedSteps != null ? FontWeight.bold : FontWeight.w400,
              color: _selectedSteps != null
                  ? Colors.black
                  : Colors.grey.shade400,
            ),
          ),

          const SizedBox(height: 16),
          const Divider(),

          const Spacer(),

          // Tombol Save
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: canSave
                    ? () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text("Saved step goal: $_selectedSteps steps"),
                          ),
                        );
                        Navigator.pop(context, _selectedSteps);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      canSave ? const Color(0xFF6A1B9A) : Colors.white,
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
                    color: canSave ? Colors.white : Colors.grey.shade500,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Picker scroll
          SizedBox(
            height: 150,
            child: CupertinoPicker(
              itemExtent: 40,
              magnification: 1.2,
              scrollController: FixedExtentScrollController(
                initialItem: (8000 - _minSteps) ~/ _stepInterval,
              ), // default ke 8000 steps
              onSelectedItemChanged: (index) {
                setState(() {
                  _selectedSteps = _minSteps + (index * _stepInterval);
                });
              },
              children: List.generate(
                ((_maxSteps - _minSteps) ~/ _stepInterval) + 1,
                (index) => Center(
                  child: Text(
                    "${_minSteps + (index * _stepInterval)} steps",
                    style: const TextStyle(fontSize: 18),
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
