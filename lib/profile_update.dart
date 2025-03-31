import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileUpdatePage extends StatefulWidget {
  final DocumentReference userRef;

  ProfileUpdatePage({required this.userRef});

  @override
  _ProfileUpdatePageState createState() => _ProfileUpdatePageState();
}


class _ProfileUpdatePageState extends State<ProfileUpdatePage> {
  TextEditingController _dobController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _diagnosisController = TextEditingController();
  TextEditingController _stomaTypeController = TextEditingController();
  TextEditingController _surgeryDateController = TextEditingController();
  TextEditingController _durationController = TextEditingController();
  TextEditingController _chemoHistoryController = TextEditingController();
  XFile? _profileImage;
  String? _imageUrl;

  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  _loadProfileData() async {
    DocumentSnapshot snapshot = await widget.userRef.get();
    var data = snapshot.data() as Map<String, dynamic>;

    _dobController.text = data['dob'] ?? '';
    _ageController.text = data['age'] ?? '';
    _genderController.text = data['gender'] ?? '';
    _diagnosisController.text = data['diagnosis'] ?? '';
    _stomaTypeController.text = data['stomaType'] ?? '';
    _surgeryDateController.text = data['surgeryDate'] ?? '';
    _durationController.text = data['duration'] ?? '';
    _chemoHistoryController.text = data['chemoHistory'] ?? '';
    _imageUrl = data['profileImage'] ?? '';  // Load the existing image URL
  }

  _saveProfileData() async {
    String? imageUrl = _imageUrl;

    if (_profileImage != null) {
      imageUrl = await _uploadImageToFirebase(_profileImage!);
    }

    await widget.userRef.update({
      'dob': _dobController.text,
      'age': _ageController.text,
      'gender': _genderController.text,
      'diagnosis': _diagnosisController.text,
      'stomaType': _stomaTypeController.text,
      'surgeryDate': _surgeryDateController.text,
      'duration': _durationController.text,
      'chemoHistory': _chemoHistoryController.text,
      'profileImage': imageUrl,
    });

    Navigator.pop(context); // Go back to the profile page
  }

  _uploadImageToFirebase(XFile image) async {
    // Create a reference to Firebase Storage
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('profile_images/${DateTime.now().millisecondsSinceEpoch}.jpg');

    // Upload the image
    UploadTask uploadTask = storageReference.putFile(File(image.path));

    // Wait for the upload to finish
    TaskSnapshot taskSnapshot = await uploadTask;

    // Get the download URL of the uploaded image
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  _pickImage() async {
    // Allow the user to choose an image from the gallery
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _profileImage = pickedFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Profile'),
        backgroundColor: Colors.lightBlue.shade200, // Same as govhos.dart
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
            colors: [Colors.lightBlue.shade200, Colors.white], // Same gradient as govhos.dart
          ),
        ),
        padding: EdgeInsets.all(8.0),
        child: ListView(
          children: [
            _buildProfileImageSection(),
            SizedBox(height: 10),
            _buildTextField('Date of Birth', _dobController),
            _buildTextField('Age', _ageController),
            _buildTextField('Gender', _genderController),
            _buildTextField('Diagnosis', _diagnosisController),
            _buildTextField('Type of Stoma', _stomaTypeController),
            _buildTextField('Date of Surgery', _surgeryDateController),
            _buildTextField('Duration', _durationController),
            _buildTextField('Chemo Therapy History', _chemoHistoryController),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveProfileData,
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImageSection() {
    return Column(
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey,
            backgroundImage: _profileImage == null
                ? (_imageUrl != null && _imageUrl!.isNotEmpty
                ? NetworkImage(_imageUrl!) as ImageProvider<Object>
                : null)
                : FileImage(File(_profileImage!.path)) as ImageProvider<Object>,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Tap to change profile picture',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
