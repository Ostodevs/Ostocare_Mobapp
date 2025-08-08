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

  // Example patient messages (replace with real data later)
  final List<Map<String, String>> patientMessages = [
    {"name": "Mr. Thenura", "message": "Stoma supplier query"},
    {"name": "Mr. Mangala", "message": "Consultation delay notice"},
    {"name": "Mr. Silva", "message": "Need urgent appointment"},
  ];

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
    const double sectionSpacing = 16; // standard vertical space
    return Scaffold(
      backgroundColor: const Color(0xFFEAF6FB),
      body: SafeArea(
        child: Column(
          children: [
            // Greeting Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 11),
                  child: Image.asset(
                    'assets/Logoostocare.png',
                    height: 85,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    alignment: Alignment.topRight,
                    margin: EdgeInsets.zero,
                    padding: const EdgeInsets.all(15),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFD5C7FF), Color(0xFFC8B5FF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(28),
                        bottomLeft: Radius.circular(28),
                        bottomRight: Radius.circular(28),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x55000000),
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
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Image.asset('assets/Cuteavatar.png', height: 80),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Main content
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: sectionSpacing),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          hintText: 'Search',
                          prefixIcon: Icon(Icons.search, size: 28),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                    SizedBox(height: sectionSpacing),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 160,
                          height: 160,
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
                              SizedBox(height: sectionSpacing),
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
                    SizedBox(height: sectionSpacing),

                    // Patients Corner
                    _buildSection(
                      "Patients Corner",
                      patientMessages.length,
                      patientMessages
                          .map(
                            (msg) => GestureDetector(
                              onTap: () {
                                debugPrint(
                                    "Open chat with ${msg['name']} (Message: ${msg['message']})");
                              },
                              child: _buildMessageTile(
                                msg["name"]!,
                                msg["message"]!,
                              ),
                            ),
                          )
                          .toList(),
                    ),

                    SizedBox(height: sectionSpacing),

                    // Nurses Corner
                    _buildSection("Nurses Corner", 1, [
                      _buildMessageTile("Mr. Thenura", "Stoma supplier query"),
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 10,
        child: SizedBox(
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

  static Widget _buildGradientCard(String day, String title, String action) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.shade300, Colors.purple.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(day,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
              const SizedBox(height: 8),
              Text(title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 14)),
              const SizedBox(height: 8),
              Text(action,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildSmallCard({
    required String title,
    String? time,
    String? number,
    bool hasIcons = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
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
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const SizedBox(height: 6),
          if (hasIcons)
            Row(
              children: [
                const Icon(Icons.circle, size: 12, color: Colors.green),
                const SizedBox(width: 4),
                const Icon(Icons.circle, size: 12, color: Colors.amber),
                const SizedBox(width: 8),
                Text(time!,
                    style: const TextStyle(fontSize: 12, color: Colors.white)),
              ],
            )
          else
            Text(number!,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildSection(String title, int newCount, List<Widget> items) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14)),
                Text(message,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              ],
            ),
          ),
          const Icon(Icons.circle, size: 12, color: Colors.cyan),
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
