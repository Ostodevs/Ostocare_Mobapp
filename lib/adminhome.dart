import 'package:flutter/material.dart';

class AdminHomePage extends StatelessWidget {
  final String userName;

  const AdminHomePage({Key? key, required this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5FD),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF3DB8FF), Color(0xFF67D1F3)]),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Image.asset("assets/Cuteavatar.png", height: 60),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        "Hello, $userName!",
                        style: const TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Column(
                      children: const [
                        Icon(Icons.health_and_safety, color: Colors.white),
                        Text("OstoCare", style: TextStyle(color: Colors.white, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Ostomy Meeting Card
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/meeting'),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFB368F1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("MON", style: TextStyle(color: Colors.white70)),
                      SizedBox(height: 4),
                      Text("1", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text("Ostomy Meeting", style: TextStyle(color: Colors.white, fontSize: 18)),
                      SizedBox(height: 4),
                      Text("View Tasks", style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Stats Cards
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatCard("Hours Worked", "7", Colors.indigo, context, '/hours'),
                  _buildStatCard("T.Patients Assigned", "10", Colors.deepPurple, context, '/patients'),
                ],
              ),
              const SizedBox(height: 16),
              _buildStatCard("Patients watched for Today", "5", Colors.blue, context, '/watched'),

              const SizedBox(height: 16),

              // Senior Admin Meeting
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/meetings'),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3A3A3A),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          "Next in 1 hour 15min",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("Senior Admin Meeting",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text("12:00 PM - 01:00 PM", style: TextStyle(color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Patient Updates
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Patient Updates", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text.rich(
                    TextSpan(
                      children: [
                        WidgetSpan(
                          child: CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.green,
                            child: Text("3", style: TextStyle(color: Colors.white, fontSize: 12)),
                          ),
                        ),
                        TextSpan(text: "  New ", style: TextStyle(color: Colors.black)),
                        TextSpan(text: "messages", style: TextStyle(color: Colors.blue)),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),

              // Notification Cards
              ..._buildPatientUpdateList(),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),

      // Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color, BuildContext context, String route) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        width: (MediaQuery.of(context).size.width - 48) / 2,
        height: 80,
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [color.withOpacity(0.85), color]),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 12)),
            const Spacer(),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPatientUpdateList() {
    final List<Map<String, dynamic>> updates = [
      {"name": "Mr. Thenura", "message": "Stoma supplier query", "status": "Change in", "value": "05", "color": Colors.green},
      {"name": "Mr. Mangala", "message": "Consultation delay notice", "status": "Overdue in", "value": "02", "color": Colors.red},
      {"name": "Mr. Rathnayaka", "message": "Consultation delay notice", "status": "Change in", "value": "02", "color": Colors.green},
    ];

    return updates.map((u) {
      return GestureDetector(
        onTap: () {
          // Future navigation to message details
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Colors.cyan[100],
            borderRadius: BorderRadius.circular(20),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            leading: const CircleAvatar(backgroundImage: AssetImage("assets/patient.png")),
            title: Text(u["name"] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(u["message"] as String),
            trailing: Container(
              width: 60,
              height: 40,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(u["status"] as String, style: const TextStyle(fontSize: 10)),
                  Text(
                    u["value"] as String,
                    style: TextStyle(color: u["color"] as Color, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }).toList();
  }
}
