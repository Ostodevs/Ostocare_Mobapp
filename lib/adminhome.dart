import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'taskpage.dart'; // Import the task page

class AdminHomePage extends StatefulWidget {
  final String userName;

  const AdminHomePage({Key? key, required this.userName}) : super(key: key);

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _selectedIndex = 0;

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

  void _goToTaskPage([String? taskName]) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskPage(taskName: taskName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const double sectionSpacing = 16;
    return Scaffold(
      backgroundColor: const Color(0xFFC2B6EE),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Image.asset(
                    'assets/Logoostocare.png',
                    height: 85,
                  ),
                ),
                const SizedBox(width: 17),
                Expanded(
                  child: Container(
                    alignment: Alignment.topRight,
                    padding: const EdgeInsets.all(30),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF91E3F5), Color(0xFF0CADD2)],
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
                            fontSize: 25,
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
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: sectionSpacing),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 200,
                          height: 200,
                          child: GestureDetector(
                            onTap: () => _goToTaskPage("Ostomy Meeting"),
                            child: _buildGradientCard(
                              "MON\n1",
                              "Ostomy Meeting",
                              "View Tasks",
                            ),
                          ),
                        ),
                        const SizedBox(width: 9),
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      height: 80,
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          onTap: () {
                                            debugPrint(
                                                "Patients watched tapped");
                                          },
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: _buildSmallCard(
                                              title: "Patients watched",
                                              number: "5",
                                              hasIcons: false,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 9),
                                  Expanded(
                                    child: SizedBox(
                                      height: 80,
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          onTap: () {
                                            debugPrint("Worked hours tapped");
                                          },
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: _buildSmallCard(
                                              title: "Worked Hours",
                                              number: "7h",
                                              hasIcons: false,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 9),
                              SizedBox(
                                height: 111,
                                child: GestureDetector(
                                  onTap: () =>
                                      _goToTaskPage("Senior Admin Meeting"),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFFA564A8),
                                          Color(0xFFF980FF)
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0xFF9333EA)
                                              .withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Senior Admin Meeting',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Container(
                                                width: 10,
                                                height: 10,
                                                decoration: const BoxDecoration(
                                                  color: Color(0xFF10B981),
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                              Container(
                                                width: 10,
                                                height: 10,
                                                decoration: const BoxDecoration(
                                                  color: Color(0xFFF59E0B),
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              const Text(
                                                '12:00 PM - 01:00 PM',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: sectionSpacing),
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
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFA564A8), Color(0xFFF980FF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF9333EA).withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
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
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 14)),
            const SizedBox(height: 8),
            Text(action,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, fontSize: 13)),
          ],
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
      padding: const EdgeInsets.all(10), // reduced padding for more space
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFA564A8), Color(0xFFF980FF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF9333EA).withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            maxLines: 2, // allow wrapping
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.start,
            style: const TextStyle(
              fontSize: 12, // slightly smaller to prevent overflow
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          if (hasIcons)
            Row(
              children: [
                const Icon(Icons.circle, size: 10, color: Colors.green),
                const SizedBox(width: 4),
                const Icon(Icons.circle, size: 10, color: Colors.amber),
                const SizedBox(width: 6),
                Text(
                  time ?? "",
                  style: const TextStyle(fontSize: 10, color: Colors.white),
                ),
              ],
            )
          else
            Text(
              number ?? "",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
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
