import 'package:flutter/material.dart';
import 'login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'auth_service.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final email = _emailController.text.trim();
      final username = _usernameController.text.trim();

      // Check if email exists in Firebase Auth
      final emailMethods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      if (emailMethods.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("This email is already in use")),
        );
        setState(() => _isLoading = false);
        return;
      }

      // Check if email exists in Firestore
      final emailQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();
      if (emailQuery.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("This email is already in use")),
        );
        setState(() => _isLoading = false);
        return;
      }

      // Check if username is taken
      final usernameQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: username)
          .get();
      if (usernameQuery.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("This username is already in use")),
        );
        setState(() => _isLoading = false);
        return;
      }

      // Proceed to sign up
      await AuthService().signUp(
        email,
        _passwordController.text.trim(),
        username,
      );

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Signup failed")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              double availableHeight = constraints.maxHeight;
              double headerHeight = availableHeight * 0.4;
              double formHeight = availableHeight - headerHeight;

              return Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.white, Colors.lightBlueAccent, Colors.blue],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(90),
                        bottomRight: Radius.circular(90),
                      ),
                    ),
                    width: double.infinity,
                    height: headerHeight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/Logoostocare.png', width: 150, height: 150),
                        SizedBox(height: 20),
                        Text("OstoCare", style: TextStyle(fontSize: 35, fontWeight: FontWeight.w200, color: Colors.white)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: ClampingScrollPhysics(),
                      child: Container(
                        constraints: BoxConstraints(minHeight: formHeight),
                        padding: EdgeInsets.all(16.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Create ", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepPurpleAccent)),
                                  Text("your account", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                                ],
                              ),
                              SizedBox(height: 50),
                              TextFormField(
                                controller: _usernameController,
                                decoration: InputDecoration(
                                  labelText: "Username",
                                  hintText: "Enter your Username                               (max. of 25 letters)",
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
                                ),
                                validator: (value) => value!.isEmpty ? "Enter a username" : null,
                              ),
                              SizedBox(height: 20),
                              TextFormField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  labelText: "Email",
                                  hintText: "Enter your Email",
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
                                ),
                                validator: (value) => value!.isEmpty || !value.contains('@') ? "Enter a valid email" : null,
                              ),
                              SizedBox(height: 20),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                decoration: InputDecoration(
                                  labelText: "Password",
                                  hintText: "Enter your Password",
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
                                  suffixIcon: IconButton(
                                    icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                ),
                                validator: (value) => value!.length < 6 ? "Password must be at least 6 characters" : null,
                              ),
                              SizedBox(height: 20),
                              TextFormField(
                                controller: _confirmPasswordController,
                                obscureText: _obscureConfirmPassword,
                                decoration: InputDecoration(
                                  labelText: "Confirm Password",
                                  hintText: "Confirm your Password",
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
                                  suffixIcon: IconButton(
                                    icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
                                    onPressed: () {
                                      setState(() {
                                        _obscureConfirmPassword = !_obscureConfirmPassword;
                                      });
                                    },
                                  ),
                                ),
                                validator: (value) => value != _passwordController.text ? "Passwords do not match" : null,
                              ),
                              SizedBox(height: 40),
                              Center(
                                child: SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _isLoading ? null : _signup,
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, padding: EdgeInsets.symmetric(vertical: 15)),
                                    child: _isLoading
                                        ? CircularProgressIndicator(color: Colors.white)
                                        : Text("Create Account", style: TextStyle(color: Colors.white, fontSize: 18)),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              Center(
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
                                  },
                                  child: Text("Already have an account? Login"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          Positioned(
            top: 20,
            left: 17,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black, size: 28),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
