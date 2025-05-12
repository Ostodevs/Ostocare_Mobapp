import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';



class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: const BackButton(color: Colors.black),
        title: const Text('Setting', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Support'),
            _card([
              _simpleTile("Help Center"),
              _simpleTile("Suggestion Improvement"),
            ]),
            const SizedBox(height: 20),
            _sectionTitle('Account'),
            _card([
              _toggleTile(
                title: "Enable Notifications",
                value: notificationsEnabled,
                onChanged: (value) => setState(() => notificationsEnabled = value),
              ),
              _simpleTile("Delete Account", icon: Icons.delete, color: Colors.red),
              _simpleTile("Logout", icon: Icons.logout, color: Colors.black),
            ]),
          ],
        ),
      ),
    );
  }

  void _showDeleteAccountOverlay() {
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Account Deletion"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: "Username"),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              final cred = EmailAuthProvider.credential(
                email: user?.email ?? '',
                password: passwordController.text.trim(),
              );

              try {
                await user?.reauthenticateWithCredential(cred);
                await user?.delete();
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/login');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Account deleted.")),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error: ${e.toString()}")),
                );
              }
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }
  void _showSuggestionOverlay() {
    final TextEditingController _controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Suggestion for Improvement"),
        content: TextField(
          controller: _controller,
          maxLines: 5,
          decoration: const InputDecoration(
            hintText: "Enter your suggestion here...",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (_controller.text.trim().isNotEmpty) {
                await FirebaseFirestore.instance.collection('suggestions').add({
                  'text': _controller.text.trim(),
                  'timestamp': Timestamp.now(),
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Suggestion submitted.')),
                );
              }
            },
            child: const Text("Submit"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }
  void _showHelpOverlay() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Help Center"),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("🔹 How to Track Progress:\nUse the 'Track Progress' screen to log your health."),
              SizedBox(height: 10),
              Text("🔹 How to Find Hospitals:\nUse the 'Find Hospitals' button on Home."),
              SizedBox(height: 10),
              Text("🔹 How to Change Bag:\nCheck countdown on Home."),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }
  void _logoutUser() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }



  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(title,
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
    );
  }

  Widget _card(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF4EFFF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: List.generate(
          children.length,
              (index) => Column(
            children: [
              children[index],
              if (index < children.length - 1)
                const Divider(height: 1, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }

  Widget _simpleTile(String title, {IconData? icon, Color? color}) {
    return ListTile(
      title: Text(title,
          style: TextStyle(
              fontSize: 15,
              color: color ?? Colors.black,
              fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        switch (title) {
          case "Help Center":
            _showHelpOverlay();
            break;
          case "Suggestion Improvement":
            _showSuggestionOverlay();
            break;
          case "Delete Account":
            _showDeleteAccountOverlay();
            break;
          case "Logout":
            _logoutUser();
            break;
        }
      },
    );
  }

  Widget _toggleTile({
    required String title,
    required bool value,
    required void Function(bool) onChanged,
  }) {
    return SwitchListTile(
      title: Text(title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.deepPurple,
      inactiveThumbColor: Colors.grey,
    );
  }
}






