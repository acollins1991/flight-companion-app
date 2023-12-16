import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {

  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home View'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text('Welcome to the Home View!', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}