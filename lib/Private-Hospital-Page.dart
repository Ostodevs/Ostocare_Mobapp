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
      'logo': 'lib/Assets/Logos/LankaH.jpg',
    },
    {
      'name': 'Durdans Hospital',
      'location': 'Colombo 03',
      'province': 'Western Province',
      'logo': 'assets/durdans.png'
    },
    {
      'name': 'Hemas Hospital',
      'location': 'Wattala',
      'province': 'Western Province',
      'logo': 'assets/hemas.png'
    },
    {
      'name': 'Kings Hospital',
      'location': 'Colombo 04',
      'province': 'Western Province',
      'logo': 'assets/kings.png'
    },
    {
      'name': 'Nawaloka Hospital',
      'location': 'Colombo 02',
      'province': 'Western Province',
      'logo': 'assets/nawaloka.png'
    },
    {
      'name': 'Durdans Hospital',
      'location': 'Colombo 03',
      'province': 'Western Province',
      'logo': 'assets/durdans.png'
    },
    {
      'name': 'Hemas Hospital',
      'location': 'Wattala',
      'province': 'Western Province',
      'logo': 'assets/hemas.png'
    },
    {
      'name': 'Kings Hospital',
      'location': 'Colombo 04',
      'province': 'Western Province',
      'logo': 'assets/kings.png'
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
            childAspectRatio: 1.2,
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

class HospitalCard extends StatelessWidget {
  final Map<String, String> hospital;

  const HospitalCard({super.key, required this.hospital});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.blueAccent, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(hospital['logo']!, height: 40),
            SizedBox(height: 10),
            Text(hospital['name']!),
            Text(hospital['location']!),
            Text(hospital['province']!),
          ],
        ),
      ),
    );
  }
}

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
            Navigator.pop(context); // Pops the current screen and goes back
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
