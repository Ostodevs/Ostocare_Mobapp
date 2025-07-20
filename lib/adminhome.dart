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
          padding: const EdgeInsets.all(0),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(0),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3DB8FF), Color(0xFF67D1F3)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(60),
                    bottomRight: Radius.circular(60),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.2),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset("assets/Cuteavatar.png", height: 70),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            "Hello, $userName!",
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Image.asset("assets/Logoostocare.png", height: 40),
                            const SizedBox(height: 4),
                            const Text("OstoCare",
                                style: TextStyle(color: Colors.white)),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFB368F1),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.purple.withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("MON",
                                    style: TextStyle(color: Colors.white70)),
                                SizedBox(height: 4),
                                Text("1",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(height: 8),
                                Text("Ostomy Meeting",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18)),
                                SizedBox(height: 4),
                                Text("View Tasks",
                                    style: TextStyle(color: Colors.white70)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              _roundedStatCard("Hours Worked", "7",
                                  [Color(0xFF536DFE), Color(0xFF5C6BC0)]),
                              const SizedBox(height: 12),
                              _roundedStatCard("T.Patients Assigned", "10",
                                  [Color(0xFF7B1FA2), Color(0xFF9575CD)]),
                              const SizedBox(height: 12),
                              _roundedStatCard("Patients watched for Today",
                                  "5", [Color(0xFF1976D2), Color(0xFF64B5F6)]),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3A3A3A),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              "Next in 1 hour 15min",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text("Senior Admin Meeting",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 4),
                              Text("12:00 PM - 01:00 PM",
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 12)),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Patient Updates",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Row(
                    children: const [
                      CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.green,
                          child: Text("3",
                              style: TextStyle(
                                  fontSize: 12, color: Colors.white))),
                      SizedBox(width: 6),
                      Text("New ", style: TextStyle(fontSize: 16)),
                      Text("messages",
                          style: TextStyle(color: Colors.blue, fontSize: 16)),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 14),
              _messageCard("Mr. Thenura", "Stoma supplier query", "Change in",
                  "05", Colors.green, "Status"),
              _messageCard("Mr. Mangala", "Consultation delay notice",
                  "Overdue in", "02", Colors.red, "Status",
                  secondaryColor: Colors.yellow),
              _messageCard("Mr. Rathnayaka", "Consultation delay notice",
                  "Change in", "02", Colors.green, "Status"),
              _messageCard("Mr. Mangala", "Consultation delay notice",
                  "Overdue in", "02", Colors.red, "Status",
                  secondaryColor: Colors.yellow),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 4,
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: 0,
          selectedItemColor: Colors.deepPurple,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: ""),
            BottomNavigationBarItem(icon: Icon(Icons.article), label: ""),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
          ],
        ),
      ),
    );
  }

  Widget _roundedStatCard(
      String title, String value, List<Color> gradientColors) {
    return Container(
      width: double.infinity,
      height: 55,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(colors: gradientColors),
        boxShadow: [
          BoxShadow(
            color: gradientColors.last.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
              child: Text(title,
                  style: const TextStyle(color: Colors.white, fontSize: 13))),
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _messageCard(String name, String message, String statusLabel,
      String statusValue, Color statusColor, String tag,
      {Color? secondaryColor}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.cyan.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const CircleAvatar(
              backgroundImage: AssetImage("assets/patient.png"), radius: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(message),
              ],
            ),
          ),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text("Status", style: TextStyle(fontSize: 10)),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(statusLabel,
                        style: TextStyle(color: statusColor, fontSize: 10)),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: (secondaryColor ?? statusColor).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(statusValue,
                        style: TextStyle(
                            color: secondaryColor ?? statusColor,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
