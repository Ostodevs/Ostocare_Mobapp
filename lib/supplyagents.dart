import 'package:flutter/material.dart';
import 'coloplast.dart'; // Import Coloplast page
import 'hollister.dart'; // Import Hollister page
import 'surgipharma.dart';


class SupplyAgentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Gradient Header
          Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 50, left: 16, bottom: 350),
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF7FD1E1), Colors.white],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.2, 0.8],
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, size: 28),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Supply Agents",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Supply Agent Cards as Buttons
          Positioned(
            top: 120,
            left: 0,
            right: 0,
            bottom: 0,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              children: [
                SupplyAgentCard(imagePath: 'assets/coloplast.png', onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ColoplastPage()));
                }),
                SizedBox(height: 16),
                SupplyAgentCard(imagePath: 'assets/hollister.png', onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => HollisterPage()));
                }),
                SizedBox(height: 16),
                SupplyAgentCard(imagePath: 'assets/surgi.png', onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SurgiPage()));
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SupplyAgentCard extends StatelessWidget {
  final String imagePath;
  final VoidCallback onTap;

  SupplyAgentCard({required this.imagePath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 180,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Color(0xFF00AED9), width: 2),
        ),
        child: Center(
          child: Image.asset(imagePath, width: 150), // Adjust size if needed
        ),
      ),
    );
  }
}