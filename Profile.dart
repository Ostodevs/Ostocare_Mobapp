import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: PatientProfileScreen(),
  ));
}

class PatientProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile Image and Name
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.purple.shade100,
              child: Icon(Icons.person, size: 50, color: Colors.purple),
            ),
            SizedBox(height: 10),
            Text(
              "Sarah J. Brooklyn",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // Personal Information Card
            buildInfoCard([
              buildInfoRow("Date of Birth", "06.11.2003"),
              buildInfoRow("Age", "21 Years"),
              buildInfoRow("Gender", "Female"),
            ]),

            SizedBox(height: 20),

            // Medical Details Card
            buildMedicalDetailsCard(),
          ],
        ),
      ),
    );
  }

  Widget buildInfoCard(List<Widget> children) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(children: children),
      ),
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

  Widget buildMedicalDetailsCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildDropdownField("Diagnosis", ["Colorectal Cancer"], "Colorectal Cancer"),
            buildDropdownField("Type of Stoma", ["Colostomy"], "Colostomy"),
            buildInfoRow("Date of Surgery", "01.01.2001"),
            buildDropdownField("Duration", ["Temporary", "Permanent"], "Temporary"),
            buildDropdownField("Chemo Therapy History", ["Ongoing", "Completed"], "Ongoing"),
          ],
        ),
      ),
    );
  }

  Widget buildDropdownField(String label, List<String> items, String selectedItem) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 5),
          DropdownButtonFormField<String>(
            value: selectedItem,
            items: items
                .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                .toList(),
            onChanged: (value) {},
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.purple.shade100,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }
}