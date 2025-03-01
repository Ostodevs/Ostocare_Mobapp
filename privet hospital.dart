import 'package:flutter/material.dart';

void main() {
  runApp(HospitalApp());
}

class HospitalApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HospitalScreen(),
    );
  }
}

class HospitalScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity, // Takes full width
        height: double.infinity, // Takes full height
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [const Color.fromARGB(255, 184, 233, 255), Colors.white],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center, // Keeps cards centered
                  children: [
                    SizedBox(height: 20),

                    // Hospital Name (Left Aligned)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Lanka Hospitals',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 5),

                    // Location (Left Aligned)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Colombo 03',
                        style: TextStyle(fontSize: 18, color: Colors.black54),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Contact Cards (Centered)
                    InfoCard(
                      title: 'Stoma Care Unit Hotline',
                      content: '+94 111 222 3333',
                      borderColor: Colors.blue, 
                    ),
                    SizedBox(height: 20),
                    InfoCard(
                      title: 'Stoma Care Nurse 01',
                      content: 'Name : Daphne\nGender : Female\nContact : +94 77 22 3456',
                      borderColor: Colors.purple,
                    ),
                    SizedBox(height: 20),
                    InfoCard(
                      title: 'Stoma Care Nurse 02',
                      content: 'Name : Anthony\nGender : Male\nContact : +94 77 33 4567',
                      borderColor: Colors.pink, 
                    ),
                    
                    SizedBox(height: 40), // Extra space at the bottom
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String content;
  final Color borderColor;

  InfoCard({required this.title, required this.content, required this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Ensures card width matches parent
      padding: EdgeInsets.all(16), // Increased padding for better spacing
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: 2),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white.withOpacity(0.9), // Light background
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
