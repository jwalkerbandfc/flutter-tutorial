import 'package:flutter/material.dart';

void main() {
  runApp(const GameMenuApp());
}

class GameMenuApp extends StatelessWidget {
  const GameMenuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game Menu',
      theme: ThemeData(useMaterial3: true, primarySwatch: Colors.indigo),
      home: const MenuScreen(),
    );
  }
}

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sky Runner')),
      body: const Center(
        child: Text(
          'Welcome, Player!',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
