import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    _hospitalsRef = FirebaseDatabase.instance.ref('government_hospitals');
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
          'logo': value['logo'] ?? 'assets/default_logo.png',
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
            ? Center(child: CircularProgressIndicator())
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
              width: MediaQuery.of(context).size.width * 0.3,
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
  final Map<dynamic, dynamic> hospital;

  const HospitalDetailScreen({super.key, required this.hospital});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(hospital['name'] ?? 'Hospital Details'),
        backgroundColor: Colors.lightBlue.shade200,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlue.shade200, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: hospital['logo'] != null
                            ? Image.asset(
                          'assets/${hospital['logo']}',
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        )
                            : Image.asset(
                          'assets/default_hospital.png',
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 20),

                      // Hospital Name
                      Text(
                        hospital['name'] ?? 'No Name',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900,
                        ),
                      ),
                      SizedBox(height: 20),

                      // Description
                      Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        elevation: 4,
                        color: Colors.grey.shade200,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          leading: Icon(Icons.description,
                              color: Colors.blue.shade700),
                          title: Text('About'),
                          subtitle:
                          Text(hospital['description'] ?? 'Not available'),
                        ),
                      ),

                      // Details Section
                      Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        elevation: 4,
                        color: Colors.grey.shade200,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Column(
                            children: [
                              _infoTile(context, Icons.location_on, 'Location',
                                  hospital['location']),
                              _infoTile(context, Icons.map, 'Province',
                                  hospital['province']),
                              _infoTileWithCopy(
                                context,
                                Icons.phone,
                                'Contact Number',
                                hospital['contact'],
                              ),
                              _infoTileWithCopy(
                                context,
                                Icons.email,
                                'Email',
                                hospital['email'],
                              ),
                              _infoTile(context, Icons.home, 'Address',
                                  hospital['address']),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _infoTile(BuildContext context, IconData icon, String title, String? value) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue.shade700),
      title: Text(title),
      subtitle: Text(value ?? 'Not available'),
    );
  }

  Widget _infoTileWithCopy(
      BuildContext context, IconData icon, String title, String? value) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue.shade700),
      title: Text(title),
      subtitle: GestureDetector(
        onTap: () {
          if (value != null) {
            Clipboard.setData(ClipboardData(text: value));
            String message = title.toLowerCase().contains('email')
                ? 'Email address copied to clipboard'
                : 'Contact number copied to clipboard';

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );
          }
        },
        child: Text(
          value ?? 'Not available',
          style: TextStyle(
              color: Colors.blue.shade900,
              decoration: TextDecoration.underline),
        ),
      ),
    );
  }
}