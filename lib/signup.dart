import 'package:flutter/material.dart';
import 'login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_service.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}


class TopWaveClipper extends CustomClipper<Path> {
  final double direction;

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

class _SignupPageState extends State<SignupPage> with SingleTickerProviderStateMixin {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  bool _isAdminMode = false;
  final _adminIdController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late AnimationController _animationController;
  late Animation<double> _waveAnimation;
  final _nicController = TextEditingController();


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

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final email = _emailController.text.trim();
      final username = _usernameController.text.trim();
      final password = _passwordController.text.trim();

      final emailMethods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      if (emailMethods.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("This email is already in use")),
        );
        setState(() => _isLoading = false);
        return;
      }

      final collectionName = _isAdminMode ? 'admins' : 'users';

      final emailQuery = await FirebaseFirestore.instance
          .collection(collectionName)
          .where('email', isEqualTo: email)
          .get();
      if (emailQuery.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("This email is already in use")),
        );
        setState(() => _isLoading = false);
        return;
      }

      final usernameQuery = await FirebaseFirestore.instance
          .collection(collectionName)
          .where('username', isEqualTo: username)
          .get();
      if (usernameQuery.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("This username is already in use")),
        );
        setState(() => _isLoading = false);
        return;
      }

      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userId = userCredential.user!.uid;

      if (_isAdminMode) {
        await FirebaseFirestore.instance.collection('admins').doc(userId).set({
          'username': username,
          'email': email,
          'adminID': _adminIdController.text.trim(),
          'nic': _nicController.text.trim(),
        });
      } else {
        await FirebaseFirestore.instance.collection('users').doc(userId).set({
          'username': username,
          'email': email,
        });
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
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
                          TextSpan(text: _isAdminMode ? "Create " : "Create ", style: TextStyle(color: Colors.deepPurple)),
                          TextSpan(text: _isAdminMode ? "your Admin account" : "your account", style: TextStyle(color: Colors.black)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: "Username",
                      hintText: "Enter your Username                             (max. of 25 letters)",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    validator: (value) => value!.isEmpty ? "Enter your username" : null,
                  ),
                  if (_isAdminMode) ...[
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _adminIdController,
                      decoration: InputDecoration(
                        labelText: "Admin ID",
                        hintText: "Enter your Admin ID",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      validator: (value) => value!.isEmpty ? "Enter your Admin ID" : null,
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _nicController,
                      decoration: InputDecoration(
                        labelText: "NIC Number",
                        hintText: "Enter your National Identification Card number",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      validator: (value) => value!.isEmpty ? "Enter your NIC number" : null,
                    ),
                  ],
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      hintText: "Enter your email",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    validator: (value) => value!.isEmpty ? "Enter your valid email" : null,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "Enter your password",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                        onPressed: () {
                          setState(() => _obscurePassword = !_obscurePassword);
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
                      hintText: "Re-enter your password",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                      suffixIcon: IconButton(
                        icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
                        onPressed: () {
                          setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                        },
                      ),
                    ),
                    validator: (value) => value != _passwordController.text ? "Passwords do not match" : null,
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _signup,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: Text(
                        _isAdminMode ? "Create Admin Account" : "Sign Up",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => LoginPage()),
                        );
                      },
                      child: Text("Already have an account? Log In"),
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