import 'package:flutter/material.dart';

class AdminHomePage extends StatelessWidget {
  final String userName;

  const AdminHomePage({Key? key, required this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, $userName'),
      ),
      body: Center(
        child: Text(
          'Hello Admin $userName!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
