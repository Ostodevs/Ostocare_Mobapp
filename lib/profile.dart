import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profile_update.dart';
import 'settings.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName = 'Loading...';
  DocumentReference? userRef;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(child: Text("No user is logged in.")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: userRef?.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Something went wrong"));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text("No profile data available"));
          }
          var profileData = snapshot.data!.data() as Map<String, dynamic>;
          String? profilePic = profileData['profileImage'];
          String userName = profileData['username'] ?? 'No Name';
          return SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.purple.shade100,
                  backgroundImage: profilePic != null ? NetworkImage(profilePic) : null,
                  child: profilePic == null
                      ? Icon(Icons.person, size: 50, color: Colors.purple)
                      : null,
                ),
                SizedBox(height: 10),
                Text(userName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                buildInfoCard([
                  buildInfoRow("Date of Birth", profileData['dob'] ?? 'No Date'),
                  buildInfoRow("Age", profileData['age'] ?? 'No Age'),
                  buildInfoRow("Gender", profileData['gender'] ?? 'No Gender'),
                ]),
                SizedBox(height: 20),
                buildMedicalDetailsCard(profileData),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        child: Icon(Icons.edit, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                if (userRef == null) {
                  return Scaffold(
                    appBar: AppBar(title: Text('Error')),
                    body: Center(child: Text('User reference is null.')),
                  );
                }
                return ProfileUpdatePage(userRef: userRef!);
              },
            ),
          );
        },
      ),
    );
  }

  Widget buildInfoCard(List<Widget> children) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: Padding(padding: EdgeInsets.all(15), child: Column(children: children)),
    );
  }

  Widget buildInfoRow(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 5),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget buildMedicalDetailsCard(Map<String, dynamic> profileData) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildInfoRow("Diagnosis", profileData['diagnosis'] ?? 'No'),
            buildInfoRow("Type of Stoma", profileData['stomaType'] ?? 'No'),
            buildInfoRow("Date of Surgery", profileData['surgeryDate'] ?? '01/01/2000'),
            buildInfoRow("Duration", profileData['duration'] ?? 'No'),
            buildInfoRow("Chemo Therapy History", profileData['chemoHistory'] ?? 'No'),
          ],
        ),
      ),
    );
  }
}



