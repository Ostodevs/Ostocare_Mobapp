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
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildTopCards(),
              const SizedBox(height: 20),
              _buildUpcomingMeetingCard(),
              const SizedBox(height: 28),
              _buildPatientUpdatesHeader(),
              const SizedBox(height: 12),
              _buildPatientCard("Mr. Thenura", "Stoma supplier query", "05",
                  Colors.green, false),
              _buildPatientCard("Mr. Mangala", "Consultation delay notice",
                  "02", Colors.orange, true),
              _buildPatientCard("Mr. Rathnayaka", "", "02", Colors.red, false),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Image.asset("Logoostocare.png", height: 55),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Hello,",
                    style:
                        TextStyle(fontSize: 18, color: Colors.grey.shade700)),
                Text(widget.userName,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
              ],
            )
          ],
        ),
        Column(
          children: const [
            Icon(Icons.health_and_safety_outlined,
                size: 30, color: Colors.deepPurple),
            Text("OstoCare", style: TextStyle(color: Colors.deepPurple)),
          ],
        )
      ],
    );
  }

  Widget _buildTopCards() {
    return Row(
      children: [
        // Calendar Card
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF9C27B0), Color(0xFFE040FB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                    color: Colors.purple.shade100,
                    blurRadius: 8,
                    offset: const Offset(0, 6))
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text("MON",
                    style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w600,
                        fontSize: 14)),
                SizedBox(height: 6),
                Text("1",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 6),
                Text("Ostomy Meeting",
                    style: TextStyle(color: Colors.white, fontSize: 14)),
                SizedBox(height: 12),
                Text("View Tasks",
                    style: TextStyle(color: Colors.white70, fontSize: 13)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Stat Cards
        Expanded(
          flex: 3,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: _buildInfoCard("Hours Worked", "7")),
                  const SizedBox(width: 8),
                  Expanded(child: _buildInfoCard("T.Patients Assigned", "10")),
                ],
              ),
              const SizedBox(height: 8),
              _buildInfoCard("Patients watched for Today", "5",
                  doubleCard: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingMeetingCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          const Icon(Icons.access_time, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Next in 1 hour 15min",
                    style: TextStyle(color: Colors.white70, fontSize: 13)),
                SizedBox(height: 4),
                Text("Senior Admin Meeting",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: const [
              Text("12:00 PM", style: TextStyle(color: Colors.white60)),
              Text("- 01:00 PM", style: TextStyle(color: Colors.white60)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPatientUpdatesHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Patient Updates",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.green.shade700,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: const [
              Icon(Icons.mark_chat_unread, size: 16, color: Colors.white),
              SizedBox(width: 6),
              Text("3 New",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildInfoCard(String label, String count, {bool doubleCard = false}) {
    return Container(
      padding: const EdgeInsets.all(12),
      height: doubleCard ? 70 : 60,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [Colors.blueAccent, Colors.deepPurpleAccent]),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text("$label\n$count",
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _buildPatientCard(String name, String note, String minutes,
      Color statusColor, bool overdue) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.blue.shade50),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 22,
            backgroundImage: AssetImage("assets/profile.png"),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15)),
                if (note.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(note,
                        style: TextStyle(color: Colors.grey.shade700)),
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text("Status",
                    style: TextStyle(color: Colors.white, fontSize: 10)),
              ),
              const SizedBox(height: 6),
              Text(overdue ? "Overdue in $minutes" : "Change in $minutes",
                  style: const TextStyle(fontSize: 12, color: Colors.black54)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return BottomAppBar(
      color: Colors.white,
      shape: const CircularNotchedRectangle(),
      notchMargin: 6.0,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavIcon(Icons.home, 0),
            _buildNavIcon(Icons.search, 1),
            _buildNavIcon(Icons.calendar_today, 2),
            _buildNavIcon(Icons.person, 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, int index) {
    return IconButton(
      icon: Icon(
        icon,
        size: 30,
        color: _selectedIndex == index ? Colors.teal : Colors.grey.shade600,
      ),
      onPressed: () => _onItemTapped(index),
    );
  }
}
