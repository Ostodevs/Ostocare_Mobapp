import 'package:flutter/material.dart';

class ColoplastPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Gradient Background
          Container(
            height: 200, // Adjusted gradient height
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF7FD1E1), Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.2, 0.8],
              ),
            ),
          ),

          // Content
          Column(
            children: [
              SizedBox(height: 50), // Space for status bar
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
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
                      "Coloplast Products",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20), // Space between title and products

              // Product List
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: GridView.builder(
                    itemCount: productList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.85,
                    ),
                    itemBuilder: (context, index) {
                      return ProductCard(
                        imagePath: productList[index]['imagePath']!,
                        title: productList[index]['title']!,
                        description: productList[index]['description']!,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Product List
List<Map<String, String>> productList = [
  {
    'imagePath': 'images/colo1.png',
    'title': 'Assura Convex Light 1-piece drainable pouch',
    'description': 'All-in-one ileostomy or colostomy appliance for maximum discretion.',
  },
  {
    'imagePath': 'images/colo2.png',
    'title': 'Assura pediatric 1-piece drainable pouch',
    'description': 'Small pouch size provides an all-in-one child-friendly ileostomy or colostomy pouching solution.',
  },
  {
    'imagePath': 'images/colo3.png',
    'title': 'SenSura Convex Light 1-piece drainable pouch',
    'description': 'All-in-one ileostomy appliance for maximum security and discretion.',
  },
  {
    'imagePath': 'images/colo4.png',
    'title': 'SenSura Mio Click Drainable Pouch',
    'description': 'New discreet 2-piece ileostomy pouch with secure mechanical coupling providing a reassuring, audible "click".',
  },
  {
    'imagePath': 'images/colo5.png',
    'title': 'Assura 2-piece barrier',
    'description': 'Includes:Extended Wear Mechanical coupling with an audible click for extra reassurance.',
  },
  {
    'imagePath': 'images/colo6.png',
    'title': 'SenSura Click drainable pouch',
    'description': 'A two-piece appliance for ileostomy or colostomy, with an audible click for extra reassurance',
  },
  {
    'imagePath': 'images/colo7.png',
    'title': 'Assura Original 2-piece drainable pouch',
    'description': 'A two-piece appliance for ileostomy, with an audible click for extra reassurance',
  },
  {
    'imagePath': 'images/colo8.png',
    'title': 'Assura pediatric 2-piece barrier',
    'description': 'Small barrier and pouch size for children, with an audible click for extra reassurance.',
  },
  {
    'imagePath': 'images/colo9.png',
    'title': 'Assura pediatric 2-piece drainable pouch',
    'description': 'Two-piece appliance for children with small pouch size and an audible click for reassurance.',
  },
  {
    'imagePath': 'images/colo10.png',
    'title': 'Assura pediatric 2-piece urostomy pouch',
    'description': 'Two-piece appliance for children with small pouch size and an audible click for reassurance.',
  },
  {
    'imagePath': 'images/colo11.png',
    'title': 'Brava Adhesive Remover Spray',
    'description': 'Sting-free and easy removal of your appliance.',
  },
  {
    'imagePath': 'images/colo12.png',
    'title': 'Brava Powder',
    'description': 'Keeps the skin dry and protects from skin irritation.',
  },
];

// Product Card Widget
class ProductCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;

  ProductCard({required this.imagePath, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFF00AED9), width: 2),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, spreadRadius: 1),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, height: 80),
            SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            SizedBox(height: 5),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey[700]),
            ),
          ],
        ),

      ),
    );
  }
}