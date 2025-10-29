import 'package:flutter/material.dart';
import 'screen/enter_screen.dart';

void main() {
  runApp(const QuibbleApp());
}

class QuibbleApp extends StatelessWidget {
  const QuibbleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quibble',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'SF Pro',
        useMaterial3: true,
      ),
      home: const EnterScreen(),
    );
  }
}