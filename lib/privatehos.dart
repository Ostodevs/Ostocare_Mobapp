import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';

class PrivateHospitalPage extends StatefulWidget {
  @override
  _PrivateHospitalPageState createState() => _PrivateHospitalPageState();
}

class _PrivateHospitalPageState extends State<PrivateHospitalPage> {
  late DatabaseReference _hospitalsRef;

  @override
  void initState() {
    super.initState();
    _hospitalsRef = FirebaseDatabase.instance.ref('hospitals');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Private Hospitals'),
        backgroundColor: Colors.lightBlue.shade200,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<DataSnapshot>(
        future: _hospitalsRef.get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.value == null) {
            return Center(child: Text('No hospitals available.'));
          }

          var hospitalsData = snapshot.data!.value as Map<dynamic, dynamic>;

          return Container(
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
              itemCount: hospitalsData.length,
              itemBuilder: (context, index) {
                var hospitalKey = hospitalsData.keys.elementAt(index);
                var hospital = hospitalsData[hospitalKey];

                String imageName = hospital['image'] ?? 'default_hospital.png';

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HospitalDetailScreen(
                          hospital: hospital,
                        ),
                      ),
                    );
                  },
                  child: HospitalCard(
                    hospital: {
                      'name': hospital['name'] ?? 'Unnamed Hospital',
                      'location': hospital['location'] ?? 'Unknown',
                      'province': hospital['province'] ?? 'Unknown',
                      'logo': 'assets/$imageName',
                    },
                  ),
                );
              },
            ),
          );
        },
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

    return Stack(
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
                      // Image at the top
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: hospital['image'] != null
                            ? Image.asset(
                          'assets/${hospital['image']}',
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

                      // Description Card
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
                          subtitle: Text(
                              hospital['description'] ?? 'Not available'),
                        ),
                      ),

                      // Details Card
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
                                hospital['contact_number'],
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