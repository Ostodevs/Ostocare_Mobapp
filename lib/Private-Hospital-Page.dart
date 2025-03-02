import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HospitalListScreen(),
    );
  }
}

class HospitalListScreen extends StatelessWidget {
  final List<Map<String, String>> hospitals = [
    {
      'name': 'Lanka Hospital',
      'location': 'Colombo 06',
      'province': 'Western Province',
      'logo': 'assets/Logos/LankaH.png',
    },
    {
      'name': 'Durdans Hospital',
      'location': 'Colombo 03',
      'province': 'Western Province',
      'logo': 'assets/Logos/LankaH.png'
    },
    {
      'name': 'Hemas Hospital',
      'location': 'Wattala',
      'province': 'Western Province',
      'logo': 'assets/Logos/LankaH.png'
    },
    {
      'name': 'Kings Hospital',
      'location': 'Colombo 04',
      'province': 'Western Province',
      'logo': 'assets/Logos/LankaH.png'
    },
    {
      'name': 'Nawaloka Hospital',
      'location': 'Colombo 02',
      'province': 'Western Province',
      'logo': 'assets/Logos/LankaH.png'
    },
    {
      'name': 'Durdans Hospital',
      'location': 'Colombo 03',
      'province': 'Western Province',
      'logo': 'assets/Logos/LankaH.png'
    },
    {
      'name': 'Hemas Hospital',
      'location': 'Wattala',
      'province': 'Western Province',
      'logo': 'assets/Logos/LankaH.png'
    },
    {
      'name': 'Kings Hospital',
      'location': 'Colombo 04',
      'province': 'Western Province',
      'logo': 'assets/Logos/LankaH.png'
    },
  ];

  HospitalListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Private Hospitals'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.9, // Adjusted for better image placement
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: hospitals.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        HospitalDetailScreen(hospital: hospitals[index]),
                  ),
                );
              },
              child: HospitalCard(hospital: hospitals[index]),
            );
          },
        ),
      ),
    );
  }
}

// CHANGED CODE STARTS HERE
class HospitalCard extends StatelessWidget {
  final Map<String, String> hospital;

  const HospitalCard({super.key, required this.hospital});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Slightly rounded corners
        side: BorderSide(color: Colors.blueAccent, width: 2),
      ),
      elevation: 4, // Added slight shadow for better UI
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 60, // Standardized image size
              width: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle, // Changed to circular image display
                color: Colors.grey[200],
              ),
              child: ClipOval(
                child: Image.asset(
                  hospital['logo']!,
                  fit: BoxFit.cover, // Ensures good image coverage
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              hospital['name']!,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              hospital['location']!,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            Text(
              hospital['province']!,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
// CHANGED CODE ENDS HERE

class HospitalDetailScreen extends StatelessWidget {
  final Map<String, String> hospital;

  const HospitalDetailScreen({super.key, required this.hospital});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(hospital['name']!),
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(hospital['logo']!, height: 80),
            SizedBox(height: 20),
            Text(hospital['name']!,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(hospital['location']!, style: TextStyle(fontSize: 18)),
            Text(hospital['province']!, style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
