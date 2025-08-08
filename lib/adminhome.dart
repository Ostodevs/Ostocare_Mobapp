import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminHomePage extends StatefulWidget {
  final String userName;

  const AdminHomePage({Key? key, required this.userName}) : super(key: key);

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _saveLastVisitedScreen();
  }

  Future<void> _saveLastVisitedScreen() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastRoute', '/adminhome');
    await prefs.setString('lastUserName', widget.userName);
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Section: Logo + Greeting
              Row(
                children: [
                  Image.asset('assets/Logoostocare.png', height: 70),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFD5C7FF), Color(0xFFC8B5FF)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade400,
                            blurRadius: 6,
                            offset: Offset(2, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Hello ${widget.userName.split(' ').first}!',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Image.asset('assets/Cuteavatar.png', height: 50),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Search Bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    prefixIcon: Icon(Icons.search, size: 28),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Action Cards
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 160,
                    height: 160,
                    child: _buildGradientCard(
                        "MON\n1", "Ostomy Meeting", "View Tasks"),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      children: [
                        _buildSmallCard(
                          title: "Senior Admin Meeting",
                          time: "12:00 PM - 01:00 PM",
                          hasIcons: true,
                        ),
                        const SizedBox(height: 10),
                        _buildSmallCard(
                          title: "Patients watched for Today",
                          number: "5",
                          hasIcons: false,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Patients Corner Section
              _buildSection("Patients Corner", 2, [
                _buildMessageTile("Mr. Thenura", "Stoma supplier query"),
                _buildMessageTile("Mr. Mangala", "Consultation delay notice"),
                _buildMessageTile("Mr. Mangala", "Consultation delay notice"),
              ]),

              const SizedBox(height: 12),

              // Nurses Corner Section
              _buildSection("Nurses Corner", 2, [
                _buildMessageTile("Mr. Thenura", "Stoma supplier query"),
              ]),
            ],
          ),
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 10,
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _navBarIcon(Icons.home, 0),
              _navBarIcon(Icons.search, 1),
              _navBarIcon(Icons.article, 2),
              _navBarIcon(Icons.person, 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGradientCard(String day, String title, String action) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.shade300, Colors.purple.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(day,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text(title, style: TextStyle(color: Colors.white, fontSize: 16)),
          SizedBox(height: 12),
          Text(action, style: TextStyle(color: Colors.white70, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildSmallCard({
    required String title,
    String? time,
    String? number,
    bool hasIcons = false,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.shade300, Colors.purple.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          SizedBox(height: 6),
          if (hasIcons)
            Row(
              children: [
                Icon(Icons.circle, size: 12, color: Colors.green),
                SizedBox(width: 4),
                Icon(Icons.circle, size: 12, color: Colors.amber),
                SizedBox(width: 8),
                Text(time!,
                    style: TextStyle(fontSize: 12, color: Colors.white)),
              ],
            )
          else
            Text(number!,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildSection(String title, int newCount, List<Widget> items) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(width: 6),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.cyan[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text("$newCount New",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.cyan[800])),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...items,
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: Text("View All",
                  style: TextStyle(
                      color: Colors.cyan[800], fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageTile(String name, String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey[300],
            child: Icon(Icons.person, color: Colors.grey[600]),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text(message,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              ],
            ),
          ),
          Icon(Icons.circle, size: 12, color: Colors.cyan),
        ],
      ),
    );
  }

  Widget _navBarIcon(IconData icon, int index) {
    return Expanded(
      child: IconButton(
        icon: Icon(icon,
            size: 28,
            color: _selectedIndex == index ? Colors.deepPurple : Colors.grey),
        onPressed: () => _onItemTapped(index),
      ),
    );
  }
}
