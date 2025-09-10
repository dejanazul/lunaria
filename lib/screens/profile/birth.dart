import 'package:flutter/material.dart';

class BirthDatePage extends StatefulWidget {
  const BirthDatePage({super.key});

  @override
  State<BirthDatePage> createState() => _BirthDatePageState();
}

class _BirthDatePageState extends State<BirthDatePage> {
  final DateTime _selectedDate = DateTime(2000, 5, 20); // default tanggal lahir
  DateTime? _editedDate; // kalau user ubah

  Future<void> _pickDate() async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (newDate != null && newDate != _selectedDate) {
      setState(() {
        _editedDate = newDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool canSave = _editedDate != null;

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
          "Edit Birth Date",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 16),

            // Field tanggal lahir langsung tampil
            InkWell(
              onTap: _pickDate,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _editedDate != null
                          ? "${_editedDate!.day}/${_editedDate!.month}/${_editedDate!.year}"
                          : "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Icon(Icons.calendar_today, size: 20),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // Tombol save
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: canSave
                    ? () {
                        DateTime newDate = _editedDate!;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Saved: $newDate")),
                        );
                        Navigator.pop(context, newDate);
                      }
                    : null, // disable kalau belum ubah
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
          ],
        ),
      ),
    );
  }
}
