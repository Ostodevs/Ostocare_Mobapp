import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:typed_data';

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  XFile? _imageFile;
  final TextEditingController _captionController = TextEditingController();
  bool _isLoading = false;
  double _uploadProgress = 0;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
      print('Image file path: ${_imageFile!.path}');
      print('Image file name: ${_imageFile!.name}');
    }
  }

  Future<void> _uploadPost() async {
    if (_imageFile == null || _captionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an image and enter a caption')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) throw Exception("User not authenticated");

      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${_imageFile!.name}';
      final ref = FirebaseStorage.instance.ref().child('posts/$uid/$fileName');

      UploadTask uploadTask;

      if (kIsWeb) {
        final bytes = await _imageFile!.readAsBytes();
        uploadTask = ref.putData(bytes);
      } else {
        uploadTask = ref.putFile(File(_imageFile!.path));
      }

      uploadTask.snapshotEvents.listen((taskSnapshot) {
        final progress = (taskSnapshot.bytesTransferred.toDouble() /
            taskSnapshot.totalBytes.toDouble()) *
            100;
        setState(() {
          _uploadProgress = progress;
        });
      });

      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      print("Image uploaded successfully, URL: $downloadUrl");

      await FirebaseFirestore.instance.collection('posts').add({
        'uid': uid,
        'imageUrl': downloadUrl,
        'caption': _captionController.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Post uploaded successfully')));
      Navigator.pop(context);
    } catch (e) {
      print("Upload failed: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Upload failed. Try again.')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildImagePreview() {
    if (_imageFile == null) {
      return Container(
        height: 250,
        color: Colors.grey[300],
        child: Center(child: Text('No image selected')),
      );
    }

    if (kIsWeb) {
      return FutureBuilder<Uint8List>(
        future: _imageFile!.readAsBytes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(height: 250, child: Center(child: CircularProgressIndicator()));
          } else if (snapshot.hasError || !snapshot.hasData) {
            return Container(height: 250, child: Center(child: Text('Error loading image')));
          } else {
            return Image.memory(
              snapshot.data!,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            );
          }
        },
      );
    } else {
      return Image.file(
        File(_imageFile!.path),
        width: double.infinity,
        height: 250,
        fit: BoxFit.cover,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload Post')),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter, // Blue from bottom
            end: Alignment.topCenter, // White at the top
            colors: [Colors.lightBlue.shade200, Colors.white],
          ),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [

            _isLoading
                ? Container()
                : ElevatedButton(
              onPressed: _uploadPost,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: Text('Share', style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 10),
            Stack(
              children: [
                _buildImagePreview(),
              ],
            ),
            SizedBox(height: 0),
            Center(
              child: ElevatedButton(
                onPressed: _pickImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(9),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  minimumSize: Size(500, 50),
                ),
                child: Text(
                  _imageFile == null ? 'Select the Image' : 'Choose a different Image',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _captionController,
              decoration: InputDecoration(
                hintText: 'Write a caption...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              ),
              maxLines: 2,
            ),
            SizedBox(height: 20),
            _isLoading
                ? Column(
              children: [
                CircularProgressIndicator(value: _uploadProgress / 100),
                SizedBox(height: 20),
                Text('${_uploadProgress.toStringAsFixed(2)}% uploaded'),
              ],
            )
                : Container(),
          ],
        ),
      ),
    );
  }
}
