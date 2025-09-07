import 'package:flutter/material.dart';

class FitnessLevelPage extends StatelessWidget {
  const FitnessLevelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Fitness Level"),
        centerTitle: true,
      ),
      body: const Center(
        child: Text("Edit your Fitness Level here"),
      ),
    );
  }
}
