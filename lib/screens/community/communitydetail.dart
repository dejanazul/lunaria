import 'package:flutter/material.dart';

class Communitydetail extends StatefulWidget {
  final Map<String, dynamic> community;
  const Communitydetail({super.key, required this.community});

  @override
  State<Communitydetail> createState() => _CommunitydetailState();
}

class _CommunitydetailState extends State<Communitydetail> {
  bool joined = false;

  // state untuk like tiap postingan
  late List<bool> liked;

  // 🔹 Dummy posts per kategori
  late List<Map<String, dynamic>> posts;

  @override
  void initState() {
    super.initState();

    liked = List.generate(3, (_) => false);

    // Sesuaikan isi post dengan kategori komunitas
    posts = _generatePosts(widget.community["category"]);
  }

  List<Map<String, dynamic>> _generatePosts(String category) {
    switch (category) {
      case "Yoga":
        return [
          {
            "author": "Lina",
            "time": "10:35 AM",
            "content": "Ada tips biar pose downward dog nggak bikin pergelangan tangan sakit?",
            "comments": [
              {"author": "Andi", "text": "Coba pakai yoga block atau tekuk sedikit siku biar lebih nyaman 🙏"},
            ]
          },
          {
            "author": "Rina",
            "time": "09:50 AM",
            "content": "Aku baru coba yoga pagi ini, rasanya adem banget. Ada yang rutin tiap hari?",
            "comments": []
          },
        ];
      case "Dance":
        return [
          {
            "author": "Bima",
            "time": "11:10 AM",
            "content": "Sepatu apa yang paling nyaman buat dance hip hop?",
            "comments": [
              {"author": "Salsa", "text": "Aku pakai sneakers ringan, enak banget buat gerakan cepat!"},
            ]
          },
          {
            "author": "Dewi",
            "time": "10:20 AM",
            "content": "Ada rekomendasi lagu buat latihan dance 30 menit?",
            "comments": []
          },
        ];
      case "Zumba":
        return [
          {
            "author": "Ayu",
            "time": "08:45 AM",
            "content": "Gerakan zumba favorit kalian apa? Aku suka yang cardio mix! 🔥",
            "comments": [
              {"author": "Riko", "text": "Aku suka bagian salsa step, bikin semangat terus!"},
            ]
          },
          {
            "author": "Nana",
            "time": "07:30 AM",
            "content": "Lagu latin apa yang enak buat dipakai zumba?",
            "comments": []
          },
        ];
      case "Aerobic":
        return [
          {
            "author": "Yani",
            "time": "06:50 AM",
            "content": "Berapa lama idealnya aerobic biar nggak gampang capek?",
            "comments": [
              {"author": "Dian", "text": "Aku biasanya 30 menit, cukup buat stamina tanpa bikin overtraining."},
            ]
          },
          {
            "author": "Putra",
            "time": "06:10 AM",
            "content": "Ada step aerobik favorit nggak? Aku suka high knee!",
            "comments": []
          },
        ];
      case "HIIT":
        return [
          {
            "author": "Rizky",
            "time": "05:55 AM",
            "content": "Kalau HIIT biasanya recovery antar set berapa lama?",
            "comments": [
              {"author": "Lala", "text": "Aku biasanya 30-45 detik, biar masih dapet intensitas tinggi 💪"},
            ]
          },
          {
            "author": "Doni",
            "time": "05:30 AM",
            "content": "Baru coba HIIT 15 menit, ngos-ngosan banget tapi nagih!",
            "comments": []
          },
        ];
      case "Workout":
        return [
          {
            "author": "Fahri",
            "time": "07:15 AM",
            "content": "Push-up lebih baik tiap hari atau selang-seling?",
            "comments": [
              {"author": "Maya", "text": "Selang-seling lebih oke, biar otot ada waktu recovery 🔥"},
            ]
          },
          {
            "author": "Dani",
            "time": "06:40 AM",
            "content": "Ada yang punya tips biar squat nggak sakit di lutut?",
            "comments": []
          },
        ];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final community = widget.community;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: Text(
          community["name"],
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Card Info Komunitas
            Card(
              color: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        height: 160,
                        width: double.infinity,
                        color: Colors.grey[200],
                        child: const Icon(Icons.group, size: 70, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      community["name"],
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          community["location"],
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          community["category"],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          "${community["members"]} members",
                          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            joined = !joined;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: joined ? Colors.purple : Colors.white,
                          foregroundColor: joined ? Colors.white : Colors.purple,
                          elevation: 0,
                          side: BorderSide(color: Colors.purple.shade300, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text(
                          joined ? "Joined" : "Join Community",
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 28),

            const Text(
              "Community Updates",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),

            // 🔹 Feed berdasarkan kategori
            Column(
              children: List.generate(posts.length, (index) {
                final post = posts[index];
                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Colors.grey.shade300, width: 1),
                  ),
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.purple,
                              child: Icon(Icons.person, color: Colors.white),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  post["author"],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  post["time"],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          post["content"],
                          style: const TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  liked[index] = !liked[index];
                                });
                              },
                              child: Icon(
                                liked[index] ? Icons.favorite : Icons.favorite_border,
                                size: 22,
                                color: liked[index] ? Colors.red : Colors.grey[600],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Icon(Icons.mode_comment_outlined, size: 20, color: Colors.grey[600]),
                          ],
                        ),
                        if (post["comments"].isNotEmpty) ...[
                          const Divider(height: 20),
                          Column(
                            children: List.generate(post["comments"].length, (cIndex) {
                              final comment = post["comments"][cIndex];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const CircleAvatar(
                                      radius: 16,
                                      backgroundColor: Colors.grey,
                                      child: Icon(Icons.person, size: 16, color: Colors.white),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            comment["author"],
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13,
                                            ),
                                          ),
                                          Text(
                                            comment["text"],
                                            style: const TextStyle(fontSize: 13, color: Colors.black87),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }),
                          )
                        ]
                      ],
                    ),
                  ),
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}
