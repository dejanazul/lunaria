import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HeightPage extends StatefulWidget {
  const HeightPage({super.key});

  @override
  State<HeightPage> createState() => _HeightPageState();
}

class _HeightPageState extends State<HeightPage> {
  int? _selectedHeight; // null dulu
  final int _minHeight = 100;
  final int _maxHeight = 220;

  @override
  Widget build(BuildContext context) {
    final bool canSave = _selectedHeight != null;

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
            "What is your height?",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 32),

          // Placeholder atau hasil pilihan
          Text(
            _selectedHeight != null ? "${_selectedHeight!} cm" : "Type Here",
            style: TextStyle(
              fontSize: 22,
              fontWeight:
                  _selectedHeight != null ? FontWeight.bold : FontWeight.w400,
              color: _selectedHeight != null
                  ? Colors.black
                  : Colors.grey.shade400,
            ),
          ),

          const SizedBox(height: 16),
          const Divider(),

          const Spacer(),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: canSave
                    ? () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Saved height: $_selectedHeight cm"),
                          ),
                        );
                        Navigator.pop(context, _selectedHeight);
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
                  initialItem: 169 - _minHeight), // default ke 169 cm
              onSelectedItemChanged: (index) {
                setState(() {
                  _selectedHeight = _minHeight + index;
                });
              },
              children: List.generate(
                _maxHeight - _minHeight + 1,
                (index) => Center(
                  child: Text(
                    "${_minHeight + index} cm",
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
