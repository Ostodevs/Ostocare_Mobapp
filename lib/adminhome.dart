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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset("Logoostocare.png", height: 60),
                        SizedBox(width: 12),
                        Text(
                          "Hello, ${widget.userName}!",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Icon(Icons.health_and_safety_outlined,
                            size: 30, color: Colors.deepPurple),
                        Text("OstoCare",
                            style: TextStyle(color: Colors.deepPurple)),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Colors.purple, Colors.purpleAccent]),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("MON", style: TextStyle(color: Colors.white)),
                            Text("1",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold)),
                            Text("Ostomy Meeting",
                                style: TextStyle(color: Colors.white)),
                            SizedBox(height: 10),
                            Text("View Tasks",
                                style: TextStyle(color: Colors.white70)),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  child: _buildInfoCard("Hours Worked", "7")),
                              SizedBox(width: 8),
                              Expanded(
                                  child: _buildInfoCard(
                                      "T.Patients Assigned", "10")),
                            ],
                          ),
                          SizedBox(height: 8),
                          _buildInfoCard("Patients watched for Today", "5",
                              doubleCard: true),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Next in 1 hour 15min",
                                style: TextStyle(color: Colors.white70)),
                            Text("Senior Admin Meeting",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                  radius: 6, backgroundColor: Colors.teal),
                              SizedBox(width: 4),
                              CircleAvatar(
                                  radius: 6, backgroundColor: Colors.green),
                            ],
                          ),
                          SizedBox(height: 6),
                          Text("12:00 PM - 01:00 PM",
                              style: TextStyle(color: Colors.white54)),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Patient Updates",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green.shade800,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child:
                              Text("3", style: TextStyle(color: Colors.white)),
                        ),
                        SizedBox(width: 4),
                        Text("New",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(width: 4),
                        Text("messages",
                            style: TextStyle(color: Colors.deepPurple)),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 12),
                _buildPatientCard("Mr. Thenura", "Stoma supplier query", "05",
                    Colors.green, false),
                _buildPatientCard("Mr. Mangala", "Consultation delay notice",
                    "02", Colors.yellow, true),
                _buildPatientCard(
                    "Mr. Rathnayaka", "", "02", Colors.red, false),
                _buildPatientCard("Mr. Mangala", "Consultation delay notice",
                    "02", Colors.yellow, true),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Container(
          height: 60,
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

  Widget _buildNavIcon(IconData icon, int index) {
    return Expanded(
      child: IconButton(
        icon: Icon(
          icon,
          size: 30,
          color: _selectedIndex == index ? Colors.teal : Colors.deepPurple,
        ),
        onPressed: () => _onItemTapped(index),
      ),
    );
  }

  Widget _buildInfoCard(String label, String count, {bool doubleCard = false}) {
    return Container(
      padding: EdgeInsets.all(12),
      height: doubleCard ? 70 : 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.deepPurpleAccent]),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text("$label\n$count",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
      ),
    );
  }

  Widget _buildPatientCard(String name, String note, String minutes,
      Color statusColor, bool overdue) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.lightBlueAccent.shade100,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundImage: AssetImage("assets/profile.png"),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(width: 6),
                    Icon(Icons.circle, size: 10, color: Colors.blue),
                  ],
                ),
                if (note.isNotEmpty) Text(note),
              ],
            ),
          ),
          Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blue.shade300,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text("Status",
                    style: TextStyle(fontSize: 10, color: Colors.white)),
              ),
              SizedBox(height: 4),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: overdue ? Colors.pink.shade100 : Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Text(overdue ? "Overdue in" : "Change in",
                        style: TextStyle(fontSize: 10)),
                    SizedBox(width: 4),
                    Text(minutes,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
