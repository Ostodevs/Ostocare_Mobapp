import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.lightBlue.shade200,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.lightBlue.shade200, Colors.white],
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.2,
          children: [
            _buildSettingButton(
                context,
                "App Settings",
                Icons.settings,
                Colors.white,
                Colors.black,
                Colors.lightBlueAccent
            ),
            _buildSettingButton(
                context,
                "Notifications",
                Icons.notifications,
                Colors.white,
                Colors.black,
                Colors.purple
            ),
            _buildSettingButton(
                context,
                "Privacy",
                Icons.lock,
                Colors.white,
                Colors.black,
                Colors.purple
            ),
            _buildSettingButton(
                context,
                "Help",
                Icons.help,
                Colors.white,
                Colors.black,
                Colors.lightBlueAccent
            ),
            _buildSettingButton(
                context,
                "Log Out",
                Icons.logout,
                Colors.white,
                Colors.black,
                Colors.lightBlueAccent
            ),
            _buildSettingButton(
                context,
                "About Us",
                Icons.info,
                Colors.white,
                Colors.black,
                Colors.purple
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingButton(
      BuildContext context,
      String title,
      IconData icon,
      Color color,
      Color textColor,
      Color iconColor
      ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: [Colors.purple, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.symmetric(vertical: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 4,
        ),
        onPressed: () {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 32),
            SizedBox(height: 10),
            Text(title, style: TextStyle(fontSize: 16, color: textColor, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

