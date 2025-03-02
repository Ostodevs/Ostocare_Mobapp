import 'package:flutter/material.dart';

class PharmacyCard extends StatelessWidget {
  final String logoPath;
  final String name;
  final String brands;
  final Map<String, String> locations;

  PharmacyCard({
    required this.logoPath,
    required this.name,
    required this.brands,
    required this.locations,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: EdgeInsets.all(12),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo & Pharmacy Name
          Row(
            children: [
              Image.asset(logoPath, width: 60, height: 60), // Logo
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),

          // Available Brands
          Text(
            "Available Brands: $brands",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8),

          // Locations & Contact Numbers
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: locations.entries.map((entry) {
              return Text(
                "${entry.key}: ${entry.value}",
                style: TextStyle(fontSize: 14),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class PharmacyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // This ensures the entire background is white
      body: Stack(
        children: [
          Column(
            children: [
              // Gradient Header
              Container(
                padding: EdgeInsets.only(top: 50, left: 16, bottom: 350), // Increased bottom padding
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF7FD1E1), Colors.white],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.4, 15], // Adjust stops to stretch the gradient further
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
                      "Pharmacies",
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
          Positioned(
            top: 120, // Adjust this to move the pharmacy section higher
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      PharmacyCard(
                        logoPath: 'assets/union_chemist.png',
                        name: 'Union Chemist Pvt Ltd',
                        brands: 'Coloplast & Surgipharma',
                        locations: {
                          'Colombo': '+94 77 555 6666 / +94 22 333 4444',
                          'Kandy': '+94 88 999 4444',
                          'Kurunegala': '+94 66 777 8888',
                          'Homagama': '+94 55 222 3333 / +94 33 444 5555',
                        },
                      ),
                      PharmacyCard(
                        logoPath: 'assets/healthguard.png',
                        name: 'HealthGuard Pharmacy',
                        brands: 'Coloplast',
                        locations: {
                          'Colombo': '+94 77 555 6666 / +94 22 333 4444',
                          'Kandy': '+94 88 999 4444',
                          'Homagama': '+94 55 222 3333 / +94 33 444 5555',
                        },
                      ),
                      PharmacyCard(
                        logoPath: 'assets/harcourts.png',
                        name: 'Harcourts Pharmacy',
                        brands: 'Coloplast',
                        locations: {
                          'Colombo': '+94 77 555 6666 / +94 22 333 4444',
                          'Kandy': '+94 88 999 4444',
                          'Homagama': '+94 55 222 3333 / +94 33 444 5555',
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
