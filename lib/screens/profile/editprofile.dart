import 'package:flutter/material.dart';
import 'editfoto.dart'; // halaman edit foto

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _emailController =
      TextEditingController(text: "rizkynabilaramadhani@gmail.com");
  final TextEditingController _usernameController =
      TextEditingController(text: "@rznabilar");

  String? _initialEmail;
  String? _initialUsername;

  @override
  void initState() {
    super.initState();
    _initialEmail = _emailController.text;
    _initialUsername = _usernameController.text;

    _emailController.addListener(_checkChanges);
    _usernameController.addListener(_checkChanges);
  }

  bool _canSave = false;

  void _checkChanges() {
    setState(() {
      _canSave = _emailController.text != _initialEmail ||
          _usernameController.text != _initialUsername;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    super.dispose();
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
          "Edit Profile",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 16),

            // Foto profile (klik ke EditFotoPage)
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EditFotoPage()),
                );
              },
              child: const CircleAvatar(
                radius: 45,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 50, color: Color(0xFF7B2CBF)),
              ),
            ),

            const SizedBox(height: 24),

            // Email field
            TextField(
              controller: _emailController,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            // Username field
            TextField(
              controller: _usernameController,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              decoration: const InputDecoration(
                labelText: "Username",
                border: OutlineInputBorder(),
              ),
            ),

            const Spacer(),

            // Save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _canSave
                    ? () {
                        String newEmail = _emailController.text;
                        String newUsername = _usernameController.text;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  "Saved: $newEmail | $newUsername")),
                        );
                        Navigator.pop(context, {
                          "email": newEmail,
                          "username": newUsername,
                        });
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
