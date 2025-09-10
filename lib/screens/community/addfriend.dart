import 'package:flutter/material.dart';

class Addfriend extends StatefulWidget {
  const Addfriend({super.key});

  @override
  State<Addfriend> createState() => _AddfriendState();
}

class _AddfriendState extends State<Addfriend> {
  bool isFriendAdded = false;

  void _showAddFriendDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 80), // popup lebih besar
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: StatefulBuilder(
            builder: (context, setStateDialog) {
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Tombol Cancel di kiri atas
                    Align(
                      alignment: Alignment.topLeft,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Foto profil
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage("assets/avatar.png"), // ganti sesuai asetmu
                    ),
                    const SizedBox(height: 15),

                    // Nama
                    const Text(
                      "Liliana Putri",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),

                    // Lokasi
                    const Text(
                      "Special Region of Yogyakarta, Indonesia",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 25),

                    // Tombol Add Friend
                    ElevatedButton.icon(
                      onPressed: () {
                        setStateDialog(() {
                          isFriendAdded = !isFriendAdded;
                        });
                        if (isFriendAdded) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Friend request sent")),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isFriendAdded
                            ? Colors.white
                            : Colors.white.withOpacity(0.8),
                        foregroundColor:
                            isFriendAdded ? Colors.purple : Colors.purple,
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ).copyWith(
                        backgroundColor: WidgetStateProperty.all(
                          isFriendAdded ? Colors.purple : Colors.white,
                        ),
                        foregroundColor: WidgetStateProperty.all(
                          isFriendAdded ? Colors.white : Colors.purple,
                        ),
                      ),
                      icon: const Icon(Icons.person_add),
                      label: Text(isFriendAdded ? "Friend Added" : "Add to Friend"),
                    )
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Add Friend"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(25),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "@lilianaps",
                  border: InputBorder.none,
                  icon: Icon(Icons.search),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Card user
            GestureDetector(
              onTap: _showAddFriendDialog,
              child: Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: const [
                    CircleAvatar(
                      radius: 28,
                      backgroundImage: AssetImage("assets/avatar.png"), // ganti aset
                    ),
                    SizedBox(width: 14),
                    Text(
                      "Liliana Putri",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
