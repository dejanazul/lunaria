import 'package:flutter/material.dart';

class EditFotoPage extends StatefulWidget {
  const EditFotoPage({super.key});

  @override
  State<EditFotoPage> createState() => _EditFotoPageState();
}

class _EditFotoPageState extends State<EditFotoPage> {
  String? _photoPath; // simpan path foto baru
  bool _canSave = false;

  void _pickPhoto() async {
    // Simulasi pilih foto (sementara pakai asset / network image dummy)
    // Nanti gampang diganti pake image_picker
    setState(() {
      _photoPath =
          "https://via.placeholder.com/150"; // contoh foto dummy online
      _canSave = true;
    });
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
          "Edit Photo",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 16),

            // Preview foto
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white,
              backgroundImage: _photoPath != null ? NetworkImage(_photoPath!) : null,
              child: _photoPath == null
                  ? const Icon(Icons.person, size: 60, color: Color(0xFF7B2CBF))
                  : null,
            ),

            const SizedBox(height: 24),

            // Tombol pilih foto
            ElevatedButton(
              onPressed: _pickPhoto,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF7B2CBF),
                side: const BorderSide(color: Color(0xFF7B2CBF)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
              ),
              child: const Text("Upload Photo"),
            ),

            const Spacer(),

            // Tombol save
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _canSave
                    ? () {
                        Navigator.pop(context, _photoPath);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Photo saved")),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _canSave ? const Color(0xFF6A1B9A) : Colors.white,
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
                    color: _canSave ? Colors.white : Colors.grey.shade500,
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
