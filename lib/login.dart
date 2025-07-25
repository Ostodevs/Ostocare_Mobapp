import 'package:flutter/material.dart';
import 'signup.dart';
import 'home.dart';
import 'adminhome.dart';
import 'forgot_password.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ostocare/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class TopWaveClipper extends CustomClipper<Path> {
  final double direction; // 1.0 for normal, -1.0 for flipped

  TopWaveClipper({required this.direction});

  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
      size.width * 0.15, size.height - 40 + (60 * direction),
      size.width * 0.5, size.height - 40,
    );
    path.quadraticBezierTo(
      size.width * 0.85, size.height - 40 - (50 * direction),
      size.width, size.height - 40,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant TopWaveClipper oldClipper) =>
      oldClipper.direction != direction;
}

class RightOvalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(size.width, size.height / 2, 0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class LeftOvalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(size.width, 0);
    path.quadraticBezierTo(0, size.height / 2, size.width, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  bool _isObscure = true;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isAdminMode = false;
  final _adminIdController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _waveAnimation = Tween<double>(begin: 1.0, end: -1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final username = _usernameController.text.trim();
      final password = _passwordController.text.trim();

      if (_isAdminMode) {
        final adminId = _adminIdController.text.trim();

        final querySnapshot = await FirebaseFirestore.instance
            .collection('admins')
            .where('username', isEqualTo: username)
            .get();

        if (querySnapshot.docs.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Invalid User")),
          );
          return;
        }

        final adminData = querySnapshot.docs.first.data();
        final email = adminData['email'];
        final storedAdminId = adminData['adminID'];

        if (storedAdminId != adminId) {
          // Case: Admin ID does not match the username
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Admin ID is not matched with the Username")),
          );
          return;
        }

        try {
          final userCredential = await AuthService().signIn(email, password);
          final fullAdminData = await AuthService().getUserData(userCredential.user!.uid);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AdminHomePage(userName: fullAdminData?['username'] ?? 'Admin'),
            ),
          );
        } on FirebaseAuthException catch (e) {
          // Case: Password is incorrect
          String errorMessage = "Password is incorrect";
          if (e.code == 'user-not-found') {
            errorMessage = "No admin found with these credentials";
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        }

      } else {
        // Patient login
        final querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('username', isEqualTo: username)
            .get();

        if (querySnapshot.docs.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Invalid username")),
          );
          return;
        }

        final userData = querySnapshot.docs.first.data();
        final email = userData['email'];

        try {
          final userCredential = await AuthService().signIn(email, password);
          final fullUserData = await AuthService().getUserData(userCredential.user!.uid);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  HomePage(userName: fullUserData?['username'] ?? 'No Name'),
            ),
          );
        } on FirebaseAuthException catch (e) {
          String errorMessage = "Invalid password";
          if (e.code == 'user-not-found') {
            errorMessage = "No user found with this username";
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An unexpected error occurred.")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _waveAnimation,
            builder: (context, child) {
              return ClipPath(
                clipper: TopWaveClipper(direction: _waveAnimation.value),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.45,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF9CE7F8), Color(0xFF00A8CF)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/Logoostocare.png', width: 110, height: 110),
                        SizedBox(height: 10),
                        Text(
                          "OstoCare",
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.w200,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).size.height * 0.50, 20, 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(text: "Log in ", style: TextStyle(color: Colors.deepPurple)),
                          TextSpan(
                            text: _isAdminMode ? "to your Admin account" : "to your account",
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_isAdminMode)
                    Column(
                      children: [
                        SizedBox(height: 30),
                        TextFormField(
                          controller: _adminIdController,
                          decoration: InputDecoration(
                            labelText: "Admin ID",
                            hintText: "Enter your Admin ID",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                          validator: (value) =>
                          value!.isEmpty ? "Enter your Admin ID" : null,
                        ),
                      ],
                    ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: "Username",
                      hintText: "Enter your username",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    validator: (value) => value!.isEmpty ? "Enter your username" : null,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _isObscure,
                    decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "Enter your password",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                      suffixIcon: IconButton(
                        icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                      ),
                    ),
                    validator: (value) => value!.isEmpty ? "Enter your password" : null,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => ForgotPasswordPage()));
                      },
                      child: Text("Forgot Password?"),
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: Text("Login", style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => SignupPage()));
                      },
                      child: Text("Don't have an account? Sign Up"),
                    ),
                  ),
                ],
              ),
            ),
          ),

          AnimatedBuilder(
            animation: _waveAnimation,
            builder: (context, child) {
              // Calculate Y-offset based on wave value
              double yOffset = MediaQuery.of(context).size.height * 0.37 -
                  (_waveAnimation.value * 20); // Adjust `20` for more/less movement

              return Positioned(
                top: yOffset,
                right: 10,
                child: Row(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(40),
                      onTap: () {
                        if (!_isAdminMode) return;
                        setState(() {
                          _isAdminMode = false;
                        });
                        _animationController.reverse(from: 1.0);
                      },
                      child: Container(
                        height: 70,
                        width: 57,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset(
                            'assets/Lpatient.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 0),
                    InkWell(
                      borderRadius: BorderRadius.circular(40),
                      onTap: () {
                        if (_isAdminMode) return;
                        setState(() {
                          _isAdminMode = true;
                        });
                        _animationController.forward(from: 0);
                      },
                      child: Container(
                        height: 70,
                        width: 57,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF22B6D9), Color(0xFF00A8CF), Color(0xFF00A8CF)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset(
                            'assets/Lnurse.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          Positioned(
            top: 20,
            left: 10,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black, size: 28),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),

          if (_isLoading)
            Container(
              color: Colors.black54,
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}