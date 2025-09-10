import 'package:flutter/material.dart';

class Cyclehistorydetail extends StatelessWidget {
  const Cyclehistorydetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 245, 245), // 🔹 Sama kayak AppBar
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 245, 245, 245), // 🔹 Sama dengan background body
        elevation: 1, // kasih garis tipis biar terpisah
        shadowColor: Colors.black12,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Cycle Details",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Date range + dots
            _CardWrapper(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Jul 9 – Aug 10",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ...List.filled(
                          5,
                          const CircleAvatar(
                              radius: 4, backgroundColor: Colors.pink),
                        ),
                        ...List.filled(
                          5,
                          const CircleAvatar(
                              radius: 4, backgroundColor: Color(0xFFB3C7FF)),
                        ),
                        const CircleAvatar(
                            radius: 4, backgroundColor: Colors.purple),
                        ...List.filled(
                          20,
                          CircleAvatar(
                              radius: 4,
                              backgroundColor: Colors.grey.shade300),
                        ),
                      ]
                          .map((dot) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2),
                                child: dot,
                              ))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 🔹 Cycle Length Card
            const _InfoCard(
              title: "Cycle Length",
              value: "33 Days",
              status: "NORMAL",
              description:
                  "The length of this cycle was within the normal range (21–35 days). A 33-day cycle is still considered healthy and can naturally vary from month to month. Many factors, such as stress, lifestyle changes, or hormonal fluctuations, can influence cycle length without indicating any health problems.",
            ),
            const SizedBox(height: 16),

            // 🔹 Period Length Card
            const _InfoCard(
              title: "Period Length",
              value: "6 Days",
              status: "NORMAL",
              description:
                  "The length of this period was within the normal range (2–7 days). A 6-day period is still considered healthy and can be a natural variation for many people. Factors such as hormonal balance, stress levels, and overall health can influence period length without signaling any problems.",
            ),
            const SizedBox(height: 20),

            // 🔹 Bottom Info
            _CardWrapper(
              child: Column(
                children: const [
                  _BottomInfo(
                    icon: Icons.water_drop,
                    color: Colors.pink,
                    text: "Your period lasted from Jul 9 to 14",
                  ),
                  Divider(),
                  _BottomInfo(
                    icon: Icons.opacity,
                    color: Color(0xFFB3C7FF),
                    text:
                        "It’s likely that your fertile window lasted from Jul 22 to 30",
                  ),
                  Divider(),
                  _BottomInfo(
                    icon: Icons.brightness_1,
                    color: Colors.purple,
                    text: "It’s likely that you ovulated on Jul 28",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 🔹 Wrapper biar semua card konsisten
class _CardWrapper extends StatelessWidget {
  final Widget child;
  const _CardWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // full lebar
      child: Card(
        elevation: 3, // 🔹 tambahin shadow
        shadowColor: Colors.black26,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );
  }
}

// 🔹 Reusable Info Card
class _InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final String status;
  final String description;

  const _InfoCard({
    required this.title,
    required this.value,
    required this.status,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return _CardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600)),
              Row(
                children: const [
                  Icon(Icons.check_circle, color: Colors.green, size: 18),
                  SizedBox(width: 4),
                  Text(
                    "NORMAL",
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 8),
          Text(value,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
                fontSize: 13, color: Colors.black54, height: 1.4),
          ),
        ],
      ),
    );
  }
}

// 🔹 Bottom Info with Icon
class _BottomInfo extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;

  const _BottomInfo({
    required this.icon,
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14, height: 1.4),
          ),
        )
      ],
    );
  }
}
