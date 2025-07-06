import 'package:flutter/material.dart';

class AdminHomePage extends StatelessWidget {
  final String userName;

  const AdminHomePage({Key? key, required this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.blueAccent, Colors.cyan]),
                  borderRadius: BorderRadius.circular(20),
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
                        Text("OstoCare", style: TextStyle(color: Colors.white))
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Buttons Grid Section
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _buildCurvedButton(
                    context,
                    title: "Ostomy Meeting",
                    subtitle: "View Tasks",
                    color: Colors.purpleAccent,
                    onTap: () {
                      Navigator.pushNamed(context, '/meeting');
                    },
                    extra: "MON\n1",
                  ),
                  _buildStatCard(context, "Hours Worked", "7", Colors.indigo, '/hours'),
                  _buildStatCard(context, "T.Patients Assigned", "10", Colors.deepPurple, '/patients'),
                  _buildStatCard(context, "Patients watched for Today", "5", Colors.blue, '/watched'),
                  _buildMeetingCard(context),
                ],
              ),

              const SizedBox(height: 20),

              // Patient Updates Section
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

              // Notifications (dummy for now)
              ..._buildPatientUpdateList(),
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

  Widget _buildCurvedButton(BuildContext context,
      {required String title,
        required String subtitle,
        required Color color,
        required VoidCallback onTap,
        String? extra}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        height: 130,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (extra != null)
              Text(extra, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            const Spacer(),
            Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
      BuildContext context,
      String title,
      String count,
      Color color,
      String route,
      ) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        width: 160,
        height: 80,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [color.withOpacity(0.8), color]),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 12)),
            const Spacer(),
            Text(count, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildMeetingCard(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/meetings'),
      child: Container(
        width: double.infinity,
        height: 100,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[800],
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
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Senior Admin Meeting", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text("12:00 PM - 01:00 PM", style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
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
          // Navigate to patient details or message
        },
        child: Card(
          color: Colors.cyan[100],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: ListTile(
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
