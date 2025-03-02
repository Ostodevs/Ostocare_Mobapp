import 'package:flutter/material.dart';

class LankaHScreen extends StatelessWidget {
  const LankaHScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.lightBlueAccent.shade100, // Light blue at the top
              Colors.white, // White at the bottom
            ],
          ),
        ),
        child: Column(
          children: [
            // ========================= HEADER SECTION =========================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back Button
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black87),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  // Hospital Name
                  const Text(
                    'Lanka Hospitals',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Hospital Location
                  const Text(
                    "Colombo 03",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // ========================= CONTENT SECTION =========================
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: const [
                    // Hotline Info Card
                    InfoCard(
                      title: "Stoma Care Unit Hotline",
                      details: "+94 111 222 3333",
                      borderColor: Colors.blue,
                    ),
                    SizedBox(height: 16),

                    // Nurse 1 Info Card
                    InfoCard(
                      title: "Stoma Care Nurse 01",
                      details: "Name : Daphne\nGender : Female\nContact : +94 77 22 3456",
                      borderColor: Colors.purple,
                    ),
                    SizedBox(height: 16),

                    // Nurse 2 Info Card
                    InfoCard(
                      title: "Stoma Care Nurse 02",
                      details: "Name : Anthony\nGender : Male\nContact : +94 77 33 4567",
                      borderColor: Colors.pink,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ========================= INFO CARD WIDGET =========================
class InfoCard extends StatelessWidget {
  final String title;
  final String details;
  final Color borderColor;

  const InfoCard({super.key, required this.title, required this.details, required this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: 2), // Border with dynamic color
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Title
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          // Card Details
          Text(
            details,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}
