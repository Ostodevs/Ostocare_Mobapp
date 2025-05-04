import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SurgiPage extends StatefulWidget {
  @override
  _SurgiPageState createState() => _SurgiPageState();
}

class _SurgiPageState extends State<SurgiPage> {
  List<Map<String, dynamic>> productList = [];

  @override
  void initState() {
    super.initState();
    fetchProductsFromFirestore();
  }

  void fetchProductsFromFirestore() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('products')
        .doc('surgipharma')
        .collection('items')
        .get();

    final products = snapshot.docs.map((doc) => doc.data()).toList();

    setState(() {
      productList = products;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Gradient Background
          Container(
            height: 200,
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
              SizedBox(height: 50),
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
              SizedBox(height: 20),

              // Product List
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: productList.isEmpty
                      ? Center(child: CircularProgressIndicator())
                      : GridView.builder(
                    itemCount: productList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.85,
                    ),
                    itemBuilder: (context, index) {
                      final product = productList[index];
                      return ProductCard(
                        imagePath: product['imagePath'] ?? '',
                        title: product['title'] ?? '',
                        description: product['description'] ?? '',
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

class ProductCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;

  ProductCard({required this.imagePath, required this.title, required this.description});

  bool isAsset(String path) {
    return path.endsWith('.png') || path.startsWith('assets/');
  }

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
            isAsset(imagePath)
                ? Image.asset(imagePath, height: 80)
                : Image.network(imagePath, height: 80),
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
