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
      'logo': 'assets/Lanka.png',
    },
    {
      'name': 'Durdans Hospital',
      'location': 'Colombo 03',
      'province': 'Western Province',
      'logo': 'assets/Durdans.png'
    },
    {
      'name': 'Hemas Hospital',
      'location': 'Wattala',
      'province': 'Western Province',
      'logo': 'assets/Hemas.png'
    },
    {
      'name': 'Kings Hospital',
      'location': 'Colombo 04',
      'province': 'Western Province',
      'logo': 'assets/Kings.png'
    },
    {
      'name': 'Nawaloka Hospital',
      'location': 'Colombo 02',
      'province': 'Western Province',
      'logo': 'assets/Nawaloka.png'
    },
  ];

  HospitalListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Private Hospitals'),
        backgroundColor: Colors.lightBlue.shade200,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () { Navigator.pop(context); },
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
        padding: EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.4,
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
    BoxFit fitType = BoxFit.cover;
    Alignment alignment = Alignment.center;

    switch (hospital['name']) {
      case 'Lanka Hospital':
      case 'Durdans Hospital':
        alignment = Alignment.center;
        fitType = BoxFit.cover;
        break;
      case 'Hemas Hospital':
        alignment = Alignment.centerRight;
        fitType = BoxFit.cover;
        break;
      case 'Nawaloka Hospital':
        alignment = Alignment.center;
        fitType = BoxFit.cover;
        break;
      default:
        alignment = Alignment.center;
        fitType = BoxFit.cover;
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HospitalDetailScreen(hospital: hospital),
          ),
        );
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(hospital['logo']!),
                fit: fitType,
                alignment: alignment,
              ),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.blueAccent, width: 2),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.3, // Covers 50% of the box from the left
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.horizontal(left: Radius.circular(10)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hospital['name']!,
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(hospital['location']!, style: TextStyle(color: Colors.white, fontSize: 14)),
                    Text(hospital['province']!, style: TextStyle(color: Colors.white, fontSize: 14)),
                  ],
                ),
              ),
            ),
          ),
        ],
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
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(hospital['logo']!, height: 100),
            SizedBox(height: 20),
            Text(
              hospital['name']!,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(hospital['location']!, style: TextStyle(fontSize: 18)),
            Text(hospital['province']!, style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}



