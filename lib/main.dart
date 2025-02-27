import 'package:flutter/material.dart';
import 'login.dart';
import 'signup.dart';
import 'dart:async';
import 'package:flutter/material.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ostomy Care',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // State for controlling the gradient animation
  late Timer _timer;
  List<Color> _colors = [Colors.blue, Colors.lightBlueAccent];
  int _colorIndex = 0;

  @override
  void initState() {
    super.initState();
    // Timer to change the gradient colors every 5 seconds
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      setState(() {
        _colorIndex = (_colorIndex + 1) % 2;
        _colors = _colorIndex == 0
            ? [Colors.blue, Colors.lightBlueAccent]
            : [Colors.deepPurple, Colors.purpleAccent];
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: Duration(seconds: 2),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/Logoostocare.png', width: 200, height: 200),
              SizedBox(height: 20),
              Text(
                "OstoCare",
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.w200, color: Colors.white),
              ),
              SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                },
                child: Text("Login", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(primary: Colors.deepPurple, padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SignupPage()));
                },
                child: Text("Sign Up", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(primary: Colors.blue, padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

