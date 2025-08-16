import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class ProfileUpdatePage extends StatefulWidget {
  final DocumentReference userRef;

  ProfileUpdatePage({required this.userRef});

  @override
  _ProfileUpdatePageState createState() => _ProfileUpdatePageState();
}

class _ProfileUpdatePageState extends State<ProfileUpdatePage> {
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _diagnosisController = TextEditingController();
  final TextEditingController _stomaTypeController = TextEditingController();
  final TextEditingController _surgeryDateController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _chemoHistoryController = TextEditingController();

  XFile? _profileImage;
  String? _imageUrl;

  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
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
    _imageUrl = data['profileImage'] ?? '';
  }

  Future<void> _saveProfileData() async {
    try {
      String? imageUrl = _imageUrl;

      if (_profileImage != null) {
        imageUrl = await _uploadImageToFirebase(_profileImage!);
      }

      await widget.userRef.set({
        'dob': _dobController.text,
        'age': _ageController.text,
        'gender': _genderController.text,
        'diagnosis': _diagnosisController.text,
        'stomaType': _stomaTypeController.text,
        'surgeryDate': _surgeryDateController.text,
        'duration': _durationController.text,
        'chemoHistory': _chemoHistoryController.text,
        'profileImage': imageUrl,
      }, SetOptions(merge: true));

      Navigator.pop(context);
    } catch (e) {
      print("Error saving profile: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save profile. Please try again.")),
      );
    }
  }

  Future<String> _uploadImageToFirebase(XFile image) async {
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('profile_images/${DateTime.now().millisecondsSinceEpoch}.jpg');

    UploadTask uploadTask = storageReference.putFile(File(image.path));
    TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
  }

  Future<void> _pickImage() async {
    var photoStatus = await Permission.photos.request();
    var cameraStatus = await Permission.camera.request();

    if (photoStatus.isGranted && cameraStatus.isGranted) {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      setState(() {
        _profileImage = pickedFile;
      });
    } else if (photoStatus.isPermanentlyDenied ||
        cameraStatus.isPermanentlyDenied) {
      // If the user permanently denied permissions, guide them to app settings
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Permissions are permanently denied. Please enable them in App Settings.'),
          action: SnackBarAction(
            label: 'Open Settings',
            onPressed: () {
              openAppSettings(); // from permission_handler package
            },
          ),
        ),
      );
    } else {
      // If permission just denied (not permanently), show a simple message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permission denied. Cannot pick image.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Update Profile', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            _buildProfileImageSection(),
            SizedBox(height: 20),
            _buildFormSection(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveProfileData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple.shade400,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 5),
              ),
              child: Text('Save Changes', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImageSection() {
    return Center(
      child: Stack(
        children: [
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 0,
                      offset: Offset(0, 3)),
                ],
              ),
              child: ClipOval(
                child: _profileImage == null
                    ? (_imageUrl != null && _imageUrl!.isNotEmpty
                        ? Image.network(_imageUrl!, fit: BoxFit.cover)
                        : Icon(Icons.person, size: 60, color: Colors.grey))
                    : Image.file(File(_profileImage!.path), fit: BoxFit.cover),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.deepPurple,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Icon(Icons.camera_alt, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple.shade100, Colors.blue.shade100],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      // Increase the padding here
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        children: [
          _buildTextField('Date of Birth', _dobController),
          _buildTextField('Age', _ageController),
          _buildTextField('Gender', _genderController),
          _buildTextField('Diagnosis', _diagnosisController),
          _buildTextField('Type of Stoma', _stomaTypeController),
          _buildTextField('Date of Surgery', _surgeryDateController),
          _buildTextField('Duration', _durationController),
          _buildTextField('Chemo Therapy History', _chemoHistoryController),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 4),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: 'Enter $label',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }
}
