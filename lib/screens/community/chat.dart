import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  final String name; // nama lawan chat

  const Chat({super.key, this.name = "Siti Fatimahtul"});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final List<Map<String, dynamic>> messages = [
    {"fromMe": false, "text": "Halo, Nabila! 😊", "time": "10:00", "status": "none"},
    {"fromMe": true, "text": "Hi, Fatim!", "time": "10:35", "status": "read"},
  ];

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const purple = Colors.purple;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: Text(
          widget.name,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          // Chat messages
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isMe = msg["fromMe"] as bool;

                // bubble chat
                final bubble = Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: isMe ? purple : Colors.grey[300],
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(18),
                            topRight: const Radius.circular(18),
                            bottomLeft: isMe ? const Radius.circular(18) : Radius.zero,
                            bottomRight: isMe ? Radius.zero : const Radius.circular(18),
                          ),
                        ),
                        child: Text(
                          msg["text"],
                          style: TextStyle(
                            color: isMe ? Colors.white : Colors.black,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      // status (hanya kalau pesan terakhir dari kita)
                      if (isMe && index == messages.lastIndexWhere((m) => m["fromMe"] == true))
                        Padding(
                          padding: const EdgeInsets.only(top: 2, right: 6),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                msg["time"],
                                style: TextStyle(color: Colors.grey[600], fontSize: 11),
                              ),
                              const SizedBox(width: 4),
                              if (msg["status"] == "sent")
                                const Icon(Icons.check, size: 14, color: Colors.grey),
                              if (msg["status"] == "read")
                                const Icon(Icons.done_all, size: 14, color: purple),
                            ],
                          ),
                        ),
                    ],
                  ),
                );

                if (index == 0) {
                  return Column(
                    children: [
                      const SizedBox(height: 10),
                      // Divider Today (tanpa garis kiri-kanan)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: purple, width: 0.5),
                        ),
                        child: const Text(
                          "Today",
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      bubble,
                    ],
                  );
                }

                return bubble;
              },
            ),
          ),

          // Input field
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "iMessage",
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                CircleAvatar(
                  backgroundColor: purple,
                  child: const Icon(Icons.send, color: Colors.white),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
