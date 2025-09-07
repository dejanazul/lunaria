import 'package:flutter/material.dart';

class EPrivacyPage extends StatelessWidget {
  const EPrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("e-Privacy Settings"),
        centerTitle: true,
      ),
      body: const Center(
        child: Text("Adjust your e-Privacy Settings here"),
      ),
    );
  }
}
