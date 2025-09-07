import 'package:flutter/material.dart';

class Settingmessage extends StatefulWidget {
  const Settingmessage({super.key});

  @override
  State<Settingmessage> createState() => _SettingmessageState();
}

class _SettingmessageState extends State<Settingmessage> {
  bool notifOn = true;
  bool soundOn = true;
  bool vibrateOn = false;
  bool showPreview = true;
  bool groupNotif = true;
  bool mentionOnly = false;
  bool readReceipts = true;
  bool typingIndicator = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Message Settings",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 🔹 Category: Notifications
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              "Notifications",
              style: TextStyle(
                fontSize: 16, // 🔹 gedein dikit dari 15 ke 16
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Card(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: EdgeInsets.zero,
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text("Enable Notifications"),
                  activeColor: Colors.purple,
                  value: notifOn,
                  onChanged: (val) => setState(() => notifOn = val),
                ),
                const Divider(height: 0, thickness: 0.5),
                SwitchListTile(
                  title: const Text("Sound"),
                  activeColor: Colors.purple,
                  value: soundOn,
                  onChanged: (val) => setState(() => soundOn = val),
                ),
                const Divider(height: 0, thickness: 0.5),
                SwitchListTile(
                  title: const Text("Vibrate"),
                  activeColor: Colors.purple,
                  value: vibrateOn,
                  onChanged: (val) => setState(() => vibrateOn = val),
                ),
                const Divider(height: 0, thickness: 0.5),
                SwitchListTile(
                  title: const Text("Show Message Preview"),
                  activeColor: Colors.purple,
                  value: showPreview,
                  onChanged: (val) => setState(() => showPreview = val),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 🔹 Category: Group Chats
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              "Group Chats",
              style: TextStyle(
                fontSize: 16, // 🔹 konsisten gedein dikit
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Card(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: EdgeInsets.zero,
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text("Group Notifications"),
                  activeColor: Colors.purple,
                  value: groupNotif,
                  onChanged: (val) => setState(() => groupNotif = val),
                ),
                const Divider(height: 0, thickness: 0.5),
                SwitchListTile(
                  title: const Text("Mentions Only"),
                  activeColor: Colors.purple,
                  value: mentionOnly,
                  onChanged: (val) => setState(() => mentionOnly = val),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 🔹 Category: Privacy
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              "Privacy",
              style: TextStyle(
                fontSize: 16, // 🔹 gedein dikit
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Card(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: EdgeInsets.zero,
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text("Read Receipts"),
                  activeColor: Colors.purple,
                  value: readReceipts,
                  onChanged: (val) => setState(() => readReceipts = val),
                ),
                const Divider(height: 0, thickness: 0.5),
                SwitchListTile(
                  title: const Text("Typing Indicator"),
                  activeColor: Colors.purple,
                  value: typingIndicator,
                  onChanged: (val) => setState(() => typingIndicator = val),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
