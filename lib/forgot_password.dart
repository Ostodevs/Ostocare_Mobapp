import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'dart:math';
import 'package:cloud_functions/cloud_functions.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

enum ForgotStep { enterDetails, verifyCode, resetPassword }

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  ForgotStep _step = ForgotStep.enterDetails;
  String _uid = '';
  String _actualCode = '';
  Timer? _timer;
  int _secondsLeft = 300;

  void _startCountdown() {
    _secondsLeft = 300;
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() => _secondsLeft--);
      if (_secondsLeft <= 0) timer.cancel();
    });
  }

  void _verifyCode() {
    if (_codeController.text.trim() == _actualCode && _secondsLeft > 0) {
      setState(() => _step = ForgotStep.resetPassword);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid or expired code")),
      );
    }
  }

  String get formattedTime {
    int min = _secondsLeft ~/ 60;
    int sec = _secondsLeft % 60;
    return "$min:${sec.toString().padLeft(2, '0')}";
  }

  Future<void> _submitDetails() async {
    setState(() => _isLoading = true);
    String username = _usernameController.text.trim();
    String email = _emailController.text.trim();

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: username)
          .get();

      if (querySnapshot.docs.isEmpty || querySnapshot.docs.first['email'] != email) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Username or Email doesn't match")),
        );
        setState(() => _isLoading = false);
        return;
      }

      final code = (Random().nextInt(899999) + 100000).toString();
      _uid = querySnapshot.docs.first.id;
      _actualCode = code;

      // Create a document in Firestore to trigger the cloud function
      await FirebaseFirestore.instance
          .collection('password_resets')
          .add({
        'email': email,
        'code': code,
        'timestamp': Timestamp.now(),
      }).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Reset code sent to $email')),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send reset code')),
        );
      });

      setState(() {
        _step = ForgotStep.verifyCode;
        _startCountdown();
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }

    setState(() => _isLoading = false);
  }

  Future<void> _resetPassword() async {
    String newPass = _newPasswordController.text.trim();
    String confirmPass = _confirmPasswordController.text.trim();

    if (newPass != confirmPass || newPass.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Passwords must match and be at least 6 characters.")),
      );
      return;
    }

    try {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(_uid).get();
      final email = userDoc['email'];

      final callable = FirebaseFunctions.instance.httpsCallable('updateUserPassword');
      final response = await callable.call({
        'email': email,
        'newPassword': newPass,
      });

      if (response.data['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Password updated successfully!")),
        );
        Navigator.pop(context); // Go back to login
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${response.data['message']}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  Widget _buildStep() {
    switch (_step) {
      case ForgotStep.enterDetails:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: "Username",
                filled: true, // Important!
                fillColor: Colors.grey[200], // Light grey background
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              ),

            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Your Email",
                filled: true, // Important!
                fillColor: Colors.grey[200], // Light grey background
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              ),

            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitDetails,
              child: _isLoading
                  ? CircularProgressIndicator()
                  : Text(
                "Send Security Code",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                backgroundColor: Colors.blueGrey,
                foregroundColor: Colors.black87, // This will change the text color
              ),
            ),
          ],
        );

      case ForgotStep.verifyCode:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Enter the 6-digit code sent to your email",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("Expires in $formattedTime", style: TextStyle(color: Colors.red)),
            SizedBox(height: 20),
            TextFormField(
              controller: _codeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Security Code",
                filled: true, // Important!
                fillColor: Colors.grey[200], // Light grey background
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              ),

            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _verifyCode,
              child: Text(
                "Verify Code",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                backgroundColor: Colors.blueGrey,
                foregroundColor: Colors.black87,
              ),
            ),
          ],
        );

      case ForgotStep.resetPassword:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "New Password",
                filled: true, // Important!
                fillColor: Colors.grey[200], // Light grey background
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              ),

            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Confirm Password",
                filled: true, // Important!
                fillColor: Colors.grey[200], // Light grey background
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              ),

            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _resetPassword,
              child: Text(
                "Save New Password",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                backgroundColor: Colors.blueGrey,
                foregroundColor: Colors.black87,
              ),
            ),
          ],
        );
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _codeController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF9CE7F8), Color(0xFF00A8CF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent, // Important for showing gradient
        appBar: AppBar(
          title: Text("Forgot Password"),
          backgroundColor: Colors.transparent, // Transparent to show gradient
          elevation: 0,
        ),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Container(
              width: double.infinity,
              child: _buildStep(),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          height: 50,
          color: Colors.transparent, // Transparent to show gradient
        ),
      ),
    );
  }
}
