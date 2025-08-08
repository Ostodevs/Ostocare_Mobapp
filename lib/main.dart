import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'signup.dart';
import 'home.dart';
import 'profile.dart';
import 'search.dart';
import 'settings.dart';
import 'news.dart';
import 'upload.dart';
import 'supplyagents.dart';
import 'supplyselect.dart';
import 'privatehos.dart';
import 'govhos.dart';
import 'adminhome.dart';
import 'taskpage.dart';
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const FirebaseOptions firebaseOptions = FirebaseOptions(
    apiKey: 'AIzaSyBnqhJMTg02yTukW8cHyxSvbklunp7iSMw',
    authDomain: 'ostocare-491c5.firebaseapp.com',
    projectId: 'ostocare-491c5',
    storageBucket: 'ostocare-491c5.appspot.com',
    messagingSenderId: '180639517082',
    appId: '1:180639517082:web:9188b8a2a8cfd823429223',
    measurementId: 'G-RXGSZ5LSRG',
    databaseURL:
        'https://ostocare-491c5-default-rtdb.asia-southeast1.firebasedatabase.app/',
  );

  await Firebase.initializeApp(options: firebaseOptions);
  await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<Widget> _getInitialScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final lastRoute = prefs.getString('lastRoute');
    final userName = prefs.getString('lastUserName') ?? 'Some User';

    final isLoggedIn = FirebaseAuth.instance.currentUser != null;

    if (isLoggedIn && lastRoute != null) {
      if (lastRoute == '/home') return HomePage(userName: userName);
      if (lastRoute == '/adminhome') return AdminHomePage(userName: userName);
    }

    return MainPage();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _getInitialScreen(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return MaterialApp(
              home: Scaffold(body: Center(child: CircularProgressIndicator())));
        }
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Ostomy Care',
          theme: ThemeData(primarySwatch: Colors.blue),
          home: snapshot.data!,
          routes: {
            '/settings': (context) => SettingsPage(),
            '/search': (context) => SearchPage(),
            '/profile': (context) => ProfilePage(),
            '/supplyselect': (context) => SupplySelectPage(),
            '/upload': (context) => UploadPage(),
            '/supplyagents': (context) => SupplyAgentsPage(),
            '/news': (context) => NewsPage(),
            '/home': (context) => HomePage(userName: 'Some User'),
            '/privatehos': (context) => PrivateHospitalPage(),
            '/govhos': (context) => GovernmentHospitalsScreen(),
            '/login': (context) => LoginPage(),
            '/adminhome': (context) => AdminHomePage(userName: 'Some User'),
            '/taskpage': (context) => TaskPage(),
          },
        );
      },
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late Timer _timer;
  List<Color> _colors = [Colors.blue, Colors.lightBlueAccent];
  int _colorIndex = 0;

  @override
  void initState() {
    super.initState();
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
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w200,
                    color: Colors.white),
              ),
              SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
                child: Text("Login", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  minimumSize: Size(150, 50),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignupPage()));
                },
                child: Text("Sign Up", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  minimumSize: Size(150, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
