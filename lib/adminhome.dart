import 'package:flutter/material.dart';

class AdminHomePage extends StatefulWidget {
  final String userName;

  const AdminHomePage({Key? key, required this.userName}) : super(key: key);

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Optional: Add navigation logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                        radius: 28, backgroundColor: Colors.deepPurple),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Welcome,",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                        Text(widget.userName,
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Icon(Icons.notifications_none, size: 30),
                  ],
                ),
                SizedBox(height: 30),

                // Calendar Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, size: 30, color: Colors.white),
                      SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Upcoming Meeting",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white)),
                          SizedBox(height: 4),
                          Text("10:00 AM - 10:30 AM",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                // Stats Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatCard(Icons.work, "Projects", "12"),
                    _buildStatCard(Icons.check_circle, "Tasks", "34"),
                    _buildStatCard(Icons.people, "Teams", "5"),
                  ],
                ),
                SizedBox(height: 20),

                // Messages
                Text("Latest Messages",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                SizedBox(height: 10),
                _buildMessageCard("Project Update",
                    "Just completed the login module.", "Now"),
                _buildMessageCard("Client Feedback",
                    "Looks great! Let's move to QA.", "1h ago"),
                _buildMessageCard(
                    "Reminder", "Team meeting tomorrow.", "2h ago"),
              ],
            ),
          ),
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Container(
          height: 60,
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavIcon(Icons.home, 0),
              _buildNavIcon(Icons.search, 1),
              _buildNavIcon(Icons.article, 2),
              _buildNavIcon(Icons.account_circle, 3),
            ],
          ),
        ),
      ),
    );
  }

  // Nav icon builder
  Widget _buildNavIcon(IconData icon, int index) {
    return Expanded(
      child: IconButton(
        icon: Icon(
          icon,
          size: 30,
          color: _selectedIndex == index ? Colors.deepPurple : Colors.grey,
        ),
        onPressed: () => _onItemTapped(index),
      ),
    );
  }

  // Stat card builder
  Widget _buildStatCard(IconData icon, String label, String count) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 28, color: Colors.deepPurple),
            SizedBox(height: 8),
            Text(count,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(label, style: TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }

  // Message card builder
  Widget _buildMessageCard(String title, String message, String time) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: ListTile(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(message),
        trailing: Text(time, style: TextStyle(color: Colors.grey)),
      ),
    );
  }
}
