import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SettingsPage(),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent, // Set AppBar color to match top of gradient
        elevation: 0, // Remove shadow for smooth blending
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // White icon for contrast
          onPressed: () {},
        ),
      ),
      body: Column(
        children: [
          // Gradient Profile Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 30),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.white], // Blue to White Gradient
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.purple.withOpacity(0.2),
                  child: const Icon(Icons.person, size: 50, color: Colors.purple),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Sarah Brooklyn",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[100],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text("View Details", style: TextStyle(color: Colors.black)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Settings List
          Expanded(
            child: ListView(
              children: [
                _buildSettingItem(Icons.settings, "App Settings", [Colors.purple, Colors.blue]),
                _buildSettingItem(Icons.notifications, "Notifications", [Colors.purple, Colors.pink]),
                _buildSettingItem(Icons.lock, "Privacy", [Colors.blue, Colors.cyan]),
                _buildSettingItem(Icons.help, "Help", [Colors.blue, Colors.cyan]),
                _buildSettingItem(Icons.logout, "Log Out", [Colors.blue, Colors.cyan]),
                _buildSettingItem(Icons.info, "About Us", [Colors.purple, Colors.blue]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget for Settings Items
  Widget _buildSettingItem(IconData icon, String title, List<Color> gradientColors) {
    return ListTile(
      leading: ShaderMask(
        shaderCallback: (Rect bounds) {
          return LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds);
        },
        child: Icon(icon, size: 30, color: Colors.white),
      ),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      onTap: () {},
    );
  }
}
