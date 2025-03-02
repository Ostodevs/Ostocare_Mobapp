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
      'logo': 'assets/Logos/DurdansH.png'
    },
    {
      'name': 'Hemas Hospital',
      'location': 'Wattala',
      'province': 'Western Province',
      'logo': 'assets/Logos/HemasH.png'
    },
    {
      'name': 'Kings Hospital',
      'location': 'Colombo 04',
      'province': 'Western Province',
      'logo': 'assets/Logos/KingsH.png'
    },
    {
      'name': 'Nawaloka Hospital',
      'location': 'Colombo 02',
      'province': 'Western Province',
      'logo': 'assets/Logos/NawalokaH.png'
    },
  ];

  HospitalListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Private Hospitals',
          style: TextStyle(
            fontWeight: FontWeight.bold, // Bold title
            fontSize: 20,
            color: Colors.black, // Better contrast
          ),
        ),
        centerTitle: true, // Center the title
        backgroundColor: const Color(0xFFB3E5FC), // Solid light blue
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFB3E5FC), // Light blue at the top
              Color(0xFFB3E5FC), // Keep more blue at the top
              Color(0xFFE3F2FD), // Soft fade before white
              Colors.white, // Smooth transition to white
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.15, 0.3, 1.0], // Adjust color blending
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.9,
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
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.blueAccent, width: 2),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[200],
              ),
              child: ClipOval(
                child: Image.asset(
                  hospital['logo']!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.image_not_supported,
                        size: 40, color: Colors.grey);
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              hospital['name']!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              hospital['location']!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            Text(
              hospital['province']!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
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
        title: Text(
          hospital['name']!,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFB3E5FC), // Solid light blue
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFB3E5FC), // More blue at the top
              Color(0xFFB3E5FC),
              Color(0xFFE3F2FD),
              Colors.white, // Gradually fade to white
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.15, 0.3, 1.0], // Adjust transition
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                hospital['logo']!,
                height: 80,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.image_not_supported,
                      size: 80, color: Colors.grey);
                },
              ),
              const SizedBox(height: 20),
              Text(
                hospital['name']!,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                hospital['location']!,
                style: const TextStyle(fontSize: 18, color: Colors.black54),
              ),
              Text(
                hospital['province']!,
                style: const TextStyle(fontSize: 18, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
