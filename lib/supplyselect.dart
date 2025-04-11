import 'package:flutter/material.dart';
import 'pharmacy_page.dart';
import 'supplyagents.dart';

class SupplySelectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Keep background white
      body: Stack(
        children: [
          // Gradient Header
          Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 50, left: 16, bottom: 100),
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF7FD1E1), Colors.white],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.4, 1], // Stretch gradient like in Pharmacy Page
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back, size: 28),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        SizedBox(width: 8),
                        Text(
                          "I want to",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8), // Space between the two texts
                    Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Text(
                        "Select the one that applies to you",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 160, // Adjusted to move boxes lower
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30), // Adjusted padding
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: SupplyOptionCard(
                      title: "Contact Pharmacies &\nView Locations",
                      imagePath: "assets/location.png",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PharmacyPage()),

                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: SupplyOptionCard(
                      title: "Contact Suppliers &\nView Product Catalog",
                      imagePath: "assets/catalog.png",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SupplyAgentsPage()),

                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SupplyOptionCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onTap;

  SupplyOptionCard({required this.title, required this.imagePath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Makes the entire card clickable
      child: Container(
        width: double.infinity, // 💙 Make it take full width
        height: 300,
        margin: EdgeInsets.symmetric(horizontal: 1), // Same as Pharmacy Page
        padding: EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Color(0xFF00AED9), width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              spreadRadius: 2,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, width: 120, height: 120),
            SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
