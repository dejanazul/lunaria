import 'package:flutter/material.dart';
import 'package:lunaria/widgets/calendar/white_card.dart';
import 'package:lunaria/widgets/calendar/header_with_button.dart';
import 'package:lunaria/screens/calendar/symptoms.dart';
import 'package:lunaria/providers/calendar_ai_provider.dart';
import 'package:provider/provider.dart';
import 'package:lunaria/models/symptom_model.dart';

class SymptomsCard extends StatelessWidget {
  final BuildContext parentContext;

  const SymptomsCard({super.key, required this.parentContext});

  // Metode untuk mendapatkan warna berdasarkan kategori gejala
  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'mood':
        return Colors.purple.shade50;
      case 'pain':
        return Colors.red.shade50;
      case 'digestion':
        return Colors.green.shade50;
      case 'discharge':
        return Colors.orange.shade50;
      case 'sex':
        return Colors.pink.shade50;
      default:
        return Colors.blue.shade50;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Gunakan Provider untuk mengakses gejala yang disimpan
    final calendarProvider = Provider.of<CalendarAiProvider>(context);
    final symptoms = calendarProvider.getTodaysSymptoms();

    return WhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderWithButton(
            title: "Symptoms",
            buttonText: "Add +",
            onTap: () {
              showModalBottomSheet(
                context: parentContext,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const Symptoms(),
              ).then((_) {
                // Refresh setelah menambahkan gejala baru
                // Tidak perlu melakukan apa-apa karena provider sudah akan memicu rebuild
              });
            },
          ),
          const SizedBox(height: 8),

          // Jika tidak ada gejala, tampilkan teks default
          // Jika ada gejala, tampilkan daftar gejala dalam bentuk chip
          symptoms.isEmpty
              ? const Text("How are you feeling today?")
              : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Today's symptoms:"),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        symptoms.map((symptom) {
                          // Gunakan try-catch untuk menangani kemungkinan emoji tidak valid
                          try {
                            return Chip(
                              label: RichText(
                                text: TextSpan(
                                  style: const TextStyle(color: Colors.black),
                                  children: [
                                    TextSpan(
                                      text:
                                          symptom.emoji.isNotEmpty
                                              ? symptom.emoji
                                              : "",
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    if (symptom.emoji.isNotEmpty)
                                      const TextSpan(text: " "),
                                    TextSpan(
                                      text: symptom.text,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                              backgroundColor: _getCategoryColor(
                                symptom.category,
                              ),
                            );
                          } catch (e) {
                            // Jika terjadi error, gunakan tampilan alternatif tanpa emoji
                            return Chip(
                              label: Text(symptom.text),
                              backgroundColor: _getCategoryColor(
                                symptom.category,
                              ),
                            );
                          }
                        }).toList(),
                  ),
                ],
              ),
        ],
      ),
    );
  }
}
