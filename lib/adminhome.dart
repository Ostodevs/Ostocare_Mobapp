import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminHomePage extends StatefulWidget {
  final String userName;

  const AdminHomePage({Key? key, required this.userName}) : super(key: key);

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateStr = DateFormat('EEEE, MMM d').format(now);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top greeting + avatar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Hello Dr. ${widget.userName.split(' ').first}",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text(dateStr,
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[600])),
                    ],
                  ),
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: AssetImage('assets/images/avatar.png'),
                  ),
                ],
              ),
              SizedBox(height: 24),

              // Search bar
              TextField(
                decoration: InputDecoration(
                  hintText: "Search patient or record...",
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 24),

              // Action cards grid
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                physics: NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  _buildActionCard(Icons.calendar_today, "Appointments",
                      Colors.deepPurpleAccent),
                  _buildActionCard(
                      Icons.people_alt_rounded, "Patients", Colors.teal),
                  _buildActionCard(
                      Icons.notifications_active, "Alerts", Colors.orange),
                  _buildActionCard(Icons.settings, "Settings", Colors.indigo),
                ],
              ),
              SizedBox(height: 24),

              // Recent activity section
              Text("Recent Activity",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              SizedBox(height: 12),

              SizedBox(
                height: 120,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildActivityCard("John Doe", "Checked in at 9:30 AM"),
                    _buildActivityCard(
                        "Lab Results", "3 new test results available"),
                    _buildActivityCard(
                        "Anna Smith", "Scheduled appointment for tomorrow"),
                  ],
                ),
              )
            ],
          ),
        ),
      ),

      // FOOTER from home.dart (preferred style)
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: IconButton(
                  icon: Icon(Icons.home, size: 30, color: Colors.deepPurple),
                  onPressed: () => _onItemTapped(0),
                ),
              ),
              Expanded(
                child: IconButton(
                  icon: Icon(Icons.search, size: 30, color: Colors.deepPurple),
                  onPressed: () => _onItemTapped(1),
                ),
              ),
              Expanded(
                child: IconButton(
                  icon: Icon(Icons.article, size: 30, color: Colors.deepPurple),
                  onPressed: () => _onItemTapped(2),
                ),
              ),
              Expanded(
                child: IconButton(
                  icon: Icon(Icons.account_circle,
                      size: 30, color: Colors.deepPurple),
                  onPressed: () => _onItemTapped(3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(IconData icon, String title, Color color) {
    return GestureDetector(
      onTap: () {
        // Placeholder for navigation
      },
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 36, color: color),
            Spacer(),
            Text(title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))
          ],
        ),
      ),
    );
  }

  Widget _buildActivityCard(String title, String subtitle) {
    return Container(
      width: 220,
      margin: EdgeInsets.only(right: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 6),
          Text(subtitle, style: TextStyle(color: Colors.grey[600]))
        ],
      ),
    );
  }
}
