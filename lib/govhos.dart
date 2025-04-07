import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart'; // Firebase Database import
import 'package:firebase_core/firebase_core.dart';

class GovernmentHospitalsScreen extends StatefulWidget {
  @override
  _GovernmentHospitalsScreenState createState() => _GovernmentHospitalsScreenState();
}

class _GovernmentHospitalsScreenState extends State<GovernmentHospitalsScreen> {
  late DatabaseReference _hospitalsRef;
  List<Map<String, String>> hospitals = [];

  @override
  void initState() {
    super.initState();
    _hospitalsRef = FirebaseDatabase.instance.ref('government_hospitals');  // Reference to the 'government_hospitals' node
    _loadHospitals();
  }

  // Fetch hospitals data from Firebase
  void _loadHospitals() async {
    final snapshot = await _hospitalsRef.get();
    if (snapshot.exists) {
      Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
      List<Map<String, String>> loadedHospitals = [];
      data.forEach((key, value) {
        loadedHospitals.add({
          'name': value['name'] ?? 'No name',
          'location': value['location'] ?? 'No location',
          'province': value['province'] ?? 'No province',
          'logo': value['logo'] ?? 'assets/default_logo.png',  // Add default logo if not available
        });
      });

      setState(() {
        hospitals = loadedHospitals;
      });
    } else {
      print('No data available');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Government Hospitals'),
        backgroundColor: Colors.lightBlue.shade200,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
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
        child: hospitals.isEmpty
            ? Center(child: CircularProgressIndicator())  // Show loading indicator while data is loading
            : GridView.builder(
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
        title: Text(hospital['name'] ?? 'Hospital Details'),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,  // Start from the top
            end: Alignment.bottomCenter, // End at the bottom
            colors: [Colors.lightBlue.shade200, Colors.white],  // Blue at the top and white at the bottom
          ),
        ),
        width: double.infinity,  // Make the container take full width
        height: double.infinity,  // Make the container take full height
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Load the hospital image from assets dynamically based on the image name in the database
            hospital['logo'] != null
                ? Image.asset(
              'assets/${hospital['logo']}',  // Load image from assets folder
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            )
                : Image.asset(
              'assets/default_hospital.png', // Fallback if no image name exists in the database
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),

            // Display hospital name and details
            Text(
              hospital['name'] ?? 'No name',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              'Location: ${hospital['location'] ?? 'No location'}',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Province: ${hospital['province'] ?? 'No province'}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),

            // Additional details like description and contact info
            Text(
              'Description: ${hospital['description'] ?? 'No description available'}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Contact Number: ${hospital['contact_number'] ?? 'No contact number'}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Email: ${hospital['email'] ?? 'No email'}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Address: ${hospital['address'] ?? 'No address available'}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}