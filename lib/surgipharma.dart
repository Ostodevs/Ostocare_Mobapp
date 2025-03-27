import 'package:flutter/material.dart';

class SurgiPage extends StatelessWidget {
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
                      "Surgipharma Products",
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
    'imagePath': 'images/surgi1.png',
    'title': 'One Piece Open ',
    'description': 'For colostomy and ileostomy, soft hydrocolloid with Cureguard component, comfortable when sticking on the body; and lower Skin irritation',
  },
  {
    'imagePath': 'images/surgi2.png',
    'title': 'Skin Barrier',
    'description': 'Match to BAO-HEALTH pouches with same Ring lock size. Secure coupling system, avoid leakage',
  },
  {
    'imagePath': 'images/surgi3.png',
    'title': 'Two Piece Open ',
    'description': 'For colostomy and ileostomy, Odor-free and noice less pouch film; High surface filter. Allow fast air-flow.',
  },
  {
    'imagePath': 'images/surgi4.png',
    'title': 'Urostomy Bag One/Two Pcs',
    'description': 'Balance liquid flow design anti-flow back; Flexible drainage, can control the liquid easily by small finger pressure',
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
