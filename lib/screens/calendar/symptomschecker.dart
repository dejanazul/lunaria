import 'package:flutter/material.dart';

class Symptomschecker extends StatelessWidget {
  const Symptomschecker({super.key});

  Widget _buildCard({
    required String title,
    required String description,
    bool hasButton = false,
  }) {
    return Card(
      color: Colors.white, // ✅ warna card jadi putih
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Title + Button optional
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                if (hasButton)
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                    ),
                    child: const Text(
                      "Move Now",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),

            // 🔹 Description
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                fontStyle: FontStyle.italic,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Symptoms Checker",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "All Self-assessments",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black),
            ),
          ),

          // 🔹 Cards
          _buildCard(
            title: "Tender Breasts",
            description:
                "Tender breasts are a common symptom that many people experience, especially before or during their menstrual cycle. This discomfort is often caused by hormonal changes, particularly fluctuations in estrogen and progesterone levels. In most cases, it's temporary and not a sign of a serious condition, but you can track it to notice any unusual changes.",
          ),
          _buildCard(
            title: "Backache",
            description:
                "Backache is a common symptom that can occur for various reasons, including muscle strain, poor posture, or hormonal changes during the menstrual cycle. The discomfort may range from mild to severe and can affect your daily activities. Tracking when it happens can help identify patterns and possible triggers.",
          ),
          _buildCard(
            title: "Vaginal Itching",
            description:
                "Vaginal itching is a symptom that can be caused by various factors, such as yeast infections, irritation from hygiene products, or changes in vaginal pH. It may be accompanied by other symptoms like redness, swelling, or unusual discharge. Monitoring the duration and severity can help determine if medical attention is needed.",
          ),
          _buildCard(
            title: "Move to Relieve",
            description:
                "Regular physical activity can help ease discomfort and improve your overall well-being. Discover exercises tailored to your symptoms and start feeling better with simple, daily movements.",
            hasButton: true,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
