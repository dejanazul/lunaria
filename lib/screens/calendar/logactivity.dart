import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Logactivity extends StatefulWidget {
  const Logactivity({super.key});

  @override
  State<Logactivity> createState() => _LogactivityState();
}

class _LogactivityState extends State<Logactivity> {
  DateTime selectedDate = DateTime(2025, 8, 11); // contoh default
  final List<Map<String, dynamic>> activities = [
    {"time": "09:00", "title": "Go Office"},
    {"time": "19:00", "title": "Yoga Session"},
  ];

  @override
  Widget build(BuildContext context) {
    final weekDays = List.generate(7, (i) {
      final date =
          selectedDate.subtract(Duration(days: selectedDate.weekday - 1 - i));
      return date;
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Log Activity",
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 🔹 Deretan tanggal minggu
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: weekDays.map((date) {
                final isSelected = isSameDay(date, selectedDate);
                final isToday = isSameDay(date, DateTime.now());

                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDate = date;
                      });
                    },
                    child: Column(
                      children: [
                        Text(
                          DateFormat.E().format(date),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: isToday
                                ? Colors.pink.shade400
                                : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: 28,
                          height: 28,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected
                                ? Colors.pink.shade400
                                : Colors.transparent,
                          ),
                          child: Text(
                            "${date.day}",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const Divider(),

          // 🔹 Tanggal lengkap
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              DateFormat("EEEE, dd MMMM yyyy").format(selectedDate),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),

          // 🔹 List jam
          Expanded(
            child: ListView.builder(
              itemCount: 24,
              itemBuilder: (context, index) {
                final hour = index;
                final hourLabel = "${hour.toString().padLeft(2, '0')}:00";

                final activity = activities.firstWhere(
                  (a) => a["time"] == hourLabel,
                  orElse: () => {},
                );

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 50,
                        child: Text(
                          hourLabel,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: activity.isNotEmpty
                            ? Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.purple.shade400,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  activity["title"],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              )
                            : Container(
                                height: 24,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        color: Colors.black12, width: 0.6),
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),

      // 🔹 Floating Action Button → Pop Up
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple.shade400,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) => const NewActivityPopup(),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

// 🔹 Widget untuk Pop Up
class NewActivityPopup extends StatefulWidget {
  const NewActivityPopup({super.key});

  @override
  State<NewActivityPopup> createState() => _NewActivityPopupState();
}

class _NewActivityPopupState extends State<NewActivityPopup> {
  final TextEditingController titleController = TextEditingController();
  bool isAllDay = false;

  late DateTime start;
  late DateTime end;
  String periodStatus = "Currently on period";

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    start = DateTime(now.year, now.month, now.day, now.hour, 0);
    end = start.add(const Duration(hours: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // 🔹 background putih
      padding: const EdgeInsets.all(16),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 🔹 Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.purple, fontSize: 16),
                  ),
                ),
                const Text(
                  "New Activity",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Add",
                    style: TextStyle(color: Colors.purple, fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 🔹 Title Input
            TextField(
              controller: titleController,
              style: const TextStyle(fontSize: 16, color: Colors.black),
              decoration: InputDecoration(
                labelText: "Title",
                hintText: "Type here...",
                labelStyle: const TextStyle(fontSize: 16, color: Colors.black),
                hintStyle: const TextStyle(fontSize: 16, color: Colors.black38),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 All-day Switch
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("All-day",
                    style: TextStyle(fontSize: 16, color: Colors.black)),
                Switch(
                  value: isAllDay,
                  activeColor: Colors.purple,
                  onChanged: (val) {
                    setState(() => isAllDay = val);
                  },
                ),
              ],
            ),

            // 🔹 Start & End Date-Time
            ListTile(
              title: const Text("Starts",
                  style: TextStyle(fontSize: 16, color: Colors.black)),
              trailing: Text(
                DateFormat("dd MMM yyyy, HH:mm").format(start),
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            ListTile(
              title: const Text("Ends",
                  style: TextStyle(fontSize: 16, color: Colors.black)),
              trailing: Text(
                DateFormat("dd MMM yyyy, HH:mm").format(end),
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),

            const SizedBox(height: 14),

            // 🔹 Radio Button (Period Check)
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Period check! What’s your status today?",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.black),
              ),
            ),
            RadioListTile<String>(
              title: const Text("Not started yet",
                  style: TextStyle(fontSize: 16, color: Colors.black)),
              value: "Not started yet",
              groupValue: periodStatus,
              onChanged: (val) => setState(() => periodStatus = val!),
            ),
            RadioListTile<String>(
              title: const Text("Currently on period",
                  style: TextStyle(fontSize: 16, color: Colors.black)),
              value: "Currently on period",
              groupValue: periodStatus,
              onChanged: (val) => setState(() => periodStatus = val!),
            ),
            RadioListTile<String>(
              title: const Text("Period finished",
                  style: TextStyle(fontSize: 16, color: Colors.black)),
              value: "Period finished",
              groupValue: periodStatus,
              onChanged: (val) => setState(() => periodStatus = val!),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
