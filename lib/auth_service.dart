import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login.dart';
import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData && snapshot.data!.emailVerified) {
              return FutureBuilder<Map<String, dynamic>?>(
                future: AuthService().getUserData(snapshot.data!.uid),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (userSnapshot.hasData) {
                    return HomePage(userName: userSnapshot.data!['username'] ?? 'No Name');
                  }
                  return HomePage(userName: 'No Name');
                },
              );
            } else {
              return LoginPage();
            }
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } catch (e) {
      throw Exception("Failed to sign in: $e");
    }
  }

  Future<String?> signUp(String email, String password, String username) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        // Add user data to Firestore
        await _firestore.collection("users").doc(user.uid).set({
          'uid': user.uid,
          'email': email,
          'username': username,
          'createdAt': FieldValue.serverTimestamp(),
        });

        // Send email verification after successful signup
        await user.sendEmailVerification();
        return null; // Successfully signed up
      }
      return "User creation failed";
    } on FirebaseAuthException catch (e) {
      return _handleAuthError(e);
    }
  }

  Future<String?> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);

      if (!userCredential.user!.emailVerified) {
        await _auth.signOut(); // Prevent login if email is not verified
        return "Please verify your email before logging in.";
      }

      return null; // Successful login
    } on FirebaseAuthException catch (e) {
      return _handleAuthError(e);
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<String?> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null; // Password reset email sent
    } on FirebaseAuthException catch (e) {
      return _handleAuthError(e);
    }
  }

  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection("users").doc(uid).get();
      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>?;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'This email is already in use. Please login or reset your password.';
      case 'invalid-email':
        return 'The email format is invalid. Please enter a valid email.';
      case 'weak-password':
        return 'Your password is too weak. Please use a stronger password.';
      case 'user-not-found':
        return 'No user found with this email. Please check or sign up.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }
}

