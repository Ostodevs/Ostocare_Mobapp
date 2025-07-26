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
              // Greeting card
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFD5C7FF),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(color: Colors.grey.shade400, blurRadius: 8)
                  ],
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Hello ${widget.userName.split(' ').first}!',
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Image.asset('assets/Cuteavatar.png', height: 60),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Search bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    prefixIcon: Icon(Icons.search, size: 30),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Action cards
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 160, // Adjust width here
                    height: 160, // Adjust height here
                    child: _buildGradientCard(
                      "MON\n1",
                      "Ostomy Meeting",
                      "View Tasks",
                    ),
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

              // Recent Activity Title
              Text("Recent Activity",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),

              const SizedBox(height: 12),

              // Horizontal info cards
              Row(
                children: [
                  _buildInfoCard(
                      "Lab results", "3 new tests results\navailable"),
                  const SizedBox(width: 8),
                  _buildInfoCard("WH day", "Today..."),
                ],
              ),

              const SizedBox(height: 24),

              // Patients Corner
              _buildSection("Patients Corner", 2, [
                _buildPatientTile("Mr. Thenura", "Stoma supplier query"),
                _buildPatientTile("Mr. Mangala", "Consultation delay notice"),
                _buildPatientTile("Mr. Mangala", "Consultation delay notice"),
              ]),

              const SizedBox(height: 12),

              // Nurses Corner (empty structure for now)
              _buildSection("Nurses Corner", 3, []),
            ],
          ),
        ),
      ),
      // Bottom bar
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _navBarIcon(Icons.home, 0),
              _navBarIcon(Icons.search, 1),
              _navBarIcon(Icons.article, 2),
              _navBarIcon(Icons.account_circle, 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGradientCard(String day, String title, String action) {
    return Container(
      width: 160,
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

  Widget _buildSmallCard(
      {required String title,
      String? time,
      String? number,
      bool hasIcons = false}) {
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

  Widget _buildInfoCard(String title, String subtitle) {
    return Container(
      width: 160,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          SizedBox(height: 8),
          Text(subtitle, style: TextStyle(fontSize: 14)),
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
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            Text(title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(width: 6),
            Icon(Icons.fiber_manual_record, size: 10, color: Colors.cyan),
            SizedBox(width: 4),
            Text("$newCount New",
                style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 10),
        ...items,
        if (items.isNotEmpty)
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
              child: Text("View All"),
            ),
          )
      ]),
    );
  }

  Widget _buildPatientTile(String name, String message) {
    return ListTile(
      leading:
          CircleAvatar(backgroundImage: AssetImage('assets/Cuteavatar.png')),
      title: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(message),
      trailing: Icon(Icons.circle, size: 14, color: Colors.cyan),
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
