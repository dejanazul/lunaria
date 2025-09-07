import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WeightPage extends StatefulWidget {
  const WeightPage({super.key});

  @override
  State<WeightPage> createState() => _WeightPageState();
}

class _WeightPageState extends State<WeightPage> {
  int? _selectedWeight; // null dulu
  final int _minWeight = 30; // batas bawah kg
  final int _maxWeight = 200; // batas atas kg

  @override
  Widget build(BuildContext context) {
    final bool canSave = _selectedWeight != null;

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

          // Pertanyaan
          const Text(
            "What is your weight?",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 32),

          // Placeholder atau hasil pilihan
          Text(
            _selectedWeight != null ? "${_selectedWeight!} kg" : "Type Here",
            style: TextStyle(
              fontSize: 22,
              fontWeight:
                  _selectedWeight != null ? FontWeight.bold : FontWeight.w400,
              color: _selectedWeight != null
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
                            content: Text("Saved weight: $_selectedWeight kg"),
                          ),
                        );
                        Navigator.pop(context, _selectedWeight);
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
                  initialItem: 65 - _minWeight), // default ke 65 kg
              onSelectedItemChanged: (index) {
                setState(() {
                  _selectedWeight = _minWeight + index;
                });
              },
              children: List.generate(
                _maxWeight - _minWeight + 1,
                (index) => Center(
                  child: Text(
                    "${_minWeight + index} kg",
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
