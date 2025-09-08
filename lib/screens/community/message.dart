import 'package:flutter/material.dart';
import 'newmessage.dart';
import 'settingmessage.dart';
import 'chat.dart';

class Message extends StatefulWidget {
  const Message({super.key});

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> {
  final List<Map<String, dynamic>> messages = [
    {
      "name": "Siti Fatimahtul",
      "message": "You: Hi, Fatim!",
      "time": "10:35",
      "unread": false,
      "status": "read", // ✅✅ sudah dibaca
    },
    {
      "name": "Nathasya Esther",
      "message": "You: Hi, Naths!",
      "time": "10:27",
      "unread": false,
      "status": "read", // ✅✅ sudah dibaca
    },
    {
      "name": "Putri Auliya",
      "message": "You: Olahraga bareng yuk!",
      "time": "10:12",
      "unread": false,
      "status": "sent", // ✅ hanya terkirim
    },
    {
      "name": "Aziyiah Qian",
      "message": "Ayo olahraga bareng, kak!",
      "time": "10:00",
      "unread": true,
      "status": "none", // ga ada centang
    },
    {
      "name": "Ellena Theodore",
      "message": "Udah achieve berapa step hari ini?",
      "time": "9:30",
      "unread": true,
      "status": "none",
    },
    {
      "name": "Salsabila Ramadhani",
      "message": "Udah achieve berapa step hari ini?",
      "time": "9:30",
      "unread": true,
      "status": "none",
    },
  ];

  Widget _buildStatusIcon(String status) {
    const purple = Colors.purple;
    switch (status) {
      case "sent":
        return Icon(Icons.check, size: 16, color: purple); // ✅ satu centang
      case "read":
        return Icon(Icons.done_all, size: 16, color: purple); // ✅✅ dua centang
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    const purple = Colors.purple;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔙 Back + Title + Setting
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const Expanded(
                    child: Text(
                      "Messages",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Settingmessage()),
                      );
                    },
                    icon: const Icon(Icons.settings),
                  ),
                ],
              ),
            ),

            // 🔍 Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // 📩 Message list
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Chat()),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          // Avatar
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.grey[300],
                            child: const Icon(Icons.person,
                                size: 30, color: Colors.white),
                          ),
                          const SizedBox(width: 12),

                          // Name + message
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  msg["name"],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  msg["message"],
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Time + status + unread badge (kanan semua)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                msg["time"],
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _buildStatusIcon(msg["status"]),
                                  if (msg["unread"])
                                    Container(
                                      margin: const EdgeInsets.only(left: 6),
                                      width: 10,
                                      height: 10,
                                      decoration: const BoxDecoration(
                                        color: purple,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // 🔘 FAB buat New Message
      floatingActionButton: FloatingActionButton(
        backgroundColor: purple,
        onPressed: () {
          showDialog(
            context: context,
            barrierDismissible: false, // biar ga ketutup kalau klik luar
            builder: (context) => const NewMessage(), // pop up dari newmessage.dart
          );
        },
        child: const Icon(Icons.edit, color: Colors.white), // ✏️ new message
      ),
    );
  }
}
