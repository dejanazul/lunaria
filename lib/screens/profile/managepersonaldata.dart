import 'package:flutter/material.dart';

class ManageDataPage extends StatelessWidget {
  const ManageDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Manage Personal Data"),
        centerTitle: true,
      ),
      body: const Center(
        child: Text("Manage your personal data here"),
      ),
    );
  }
}