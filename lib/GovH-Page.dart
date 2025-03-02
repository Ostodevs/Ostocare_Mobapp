import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GovernmentHospitalsScreen(),
    );
  }
}

class GovernmentHospitalsScreen extends StatelessWidget {
  final List<Map<String, String>> hospitals = [
    {
      'name': 'NHSL',
      'location': 'Colombo 06',
      'province': 'Western Province',
      'logo': 'assets/GovH-logo.png'
    },
    {
      'name': 'Kandy',
      'location': 'District Hospital',
      'province': 'Central Province',
      'logo': 'assets/GovH-logo.png'
    },
    {
      'name': 'Kurunegala',
      'location': 'Base Hospital',
      'province': 'Central Province',
      'logo': 'assets/GovH-logo.png'
    },
    {
      'name': 'Gampaha',
      'location': 'Base Hospital',
      'province': 'Central Province',
      'logo': 'assets/GovH-logo.png'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Government Hospitals'),
        backgroundColor: Colors.lightBlue.shade200,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {},
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.lightBlue.shade200, Colors.white],
          ),
        ),
        padding: EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.2,
          ),
          itemCount: hospitals.length,
          itemBuilder: (context, index) {
            return HospitalCard(hospital: hospitals[index]);
          },
        ),
      ),
    );
  }
}

class HospitalCard extends StatelessWidget {
  final Map<String, String> hospital;

  HospitalCard({required this.hospital});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HospitalDetailScreen(hospital: hospital),
          ),
        );
      },
      splashColor: Colors.blue.withOpacity(0.3),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue, width: 2),
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            hospital['logo'] != null
                ? Image.asset(
              hospital['logo']!,
              height: 50,
              width: 50,
              fit: BoxFit.cover,
            )
                : Icon(Icons.local_hospital, size: 40, color: Colors.red),
            SizedBox(height: 8),
            Text(
              hospital['name']!,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
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

  HospitalDetailScreen({required this.hospital});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(hospital['name']!),
        backgroundColor: Colors.lightBlue.shade200,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              hospital['logo'] != null
                  ? Image.asset(
                hospital['logo']!,
                height: 80,
                width: 80,
                fit: BoxFit.cover,
              )
                  : Icon(Icons.local_hospital, size: 80, color: Colors.red),
              SizedBox(height: 16),
              Text(
                hospital['name']!,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                hospital['location']!,
                style: TextStyle(fontSize: 18),
              ),
              Text(
                hospital['province']!,
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
