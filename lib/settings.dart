import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  bool notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // Fetch user data from Firestore
  void _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        setState(() {
          emailController.text = userDoc['email'] ?? '';
          nameController.text = userDoc['name'] ?? '';
        });
      }
    }
  }

  void _showAppSettings(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) {
        return _buildOverlayDialog(
          context,
          title: "Account Management",
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {},
                child: Text("Delete Account"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              ),
              SizedBox(height: 12),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: "Enter Password to Deactivate"),
              ),
              SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  String enteredPassword = passwordController.text;
                  // Add your deactivation logic here
                },
                child: Text("Deactivate Account"),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showNotificationsSettings(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) {
        return _buildOverlayDialog(
          context,
          title: "Notification Preferences",
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Enable Notifications"),
                      Switch(
                        value: notificationsEnabled,
                        onChanged: (value) {
                          setState(() => notificationsEnabled = value);
                        },
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Toggle notifications for updates, reminders, and news.",
                    style: TextStyle(fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void _showPrivacySettings(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) {
        return _buildOverlayDialog(
          context,
          title: "Edit Account Information",
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Full Name"),
              ),
              SizedBox(height: 10),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: "Email Address"),
              ),
              SizedBox(height: 12),
              ElevatedButton(
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .update({
                    'name': nameController.text,
                    'email': emailController.text,
                  });

                  Navigator.pop(context);
                },
                child: Text("Save Changes"),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showHelpSection(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black45,
      builder: (context) {
        return _buildOverlayDialog(
          context,
          title: "Frequently Asked Questions",
          content: SingleChildScrollView(
            child: Column(
              children: [
                _faqTile("How can I change my email?", "Go to Privacy settings and update your email."),
                _faqTile("What happens if I deactivate my account?", "Your account is temporarily disabled and can be reactivated."),
                _faqTile("Can I get update notifications?", "Yes. Enable them under the Notifications tab."),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _faqTile(String question, String answer) {
    return ExpansionTile(
      title: Text(question, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
          child: Text(answer, style: TextStyle(fontSize: 12, color: Colors.black87)),
        )
      ],
    );
  }

  void _logout(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/login');
  }

  Widget _buildOverlayDialog(BuildContext context, {required String title, required Widget content}) {
    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Material(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              content,
              SizedBox(height: 20),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Close"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingButton(
      BuildContext context,
      String title,
      IconData icon,
      Color bgColor,
      Color textColor,
      Color iconColor,
      void Function(BuildContext) onPressedAction,
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
          backgroundColor: bgColor,
          padding: EdgeInsets.symmetric(vertical: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 4,
        ),
        onPressed: () => onPressedAction(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 32),
            SizedBox(height: 10),
            Text(title,
                style: TextStyle(fontSize: 16, color: textColor, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

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
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.lightBlue.shade200, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
              children: [
                _buildSettingButton(
                    context, "App Settings", Icons.settings, Colors.white, Colors.black, Colors.lightBlueAccent, _showAppSettings),
                _buildSettingButton(
                    context, "Notifications", Icons.notifications, Colors.white, Colors.black, Colors.purple, _showNotificationsSettings),
                _buildSettingButton(
                    context, "Privacy", Icons.lock, Colors.white, Colors.black, Colors.purple, _showPrivacySettings),
                _buildSettingButton(
                    context, "Help", Icons.help, Colors.white, Colors.black, Colors.lightBlueAccent, _showHelpSection),
                _buildSettingButton(
                    context, "Log Out", Icons.logout, Colors.white, Colors.black, Colors.lightBlueAccent, _logout),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
