import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  final List<Widget> children;

  const ProfileCard({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(children: children),
    );
  }
}
