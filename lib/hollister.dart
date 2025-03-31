import 'package:flutter/material.dart';

class HollisterPage extends StatelessWidget {
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
                      "Hollister Products",
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
    'imagePath': 'assets/hollister1.png',
    'title': 'Adapt Skin Barrier Paste',
    'description': 'Used to fill uneven skin contours to create a flatter surface. Prevents drainage from getting under the ostomy skin barrier. Help extend the wear time of the skin barrier.',
  },
  {
    'imagePath': 'assets/hollister2.png',
    'title': 'Adapt Stoma Powder',
    'description': 'Used to absorb moisture from broken skin around the stoma, which allows for better barrier adhesion to help protect the skin.',
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
