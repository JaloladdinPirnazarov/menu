import 'package:flutter/material.dart';
import 'package:menu/pages/calculator.dart';
import 'package:menu/pages/set_calculator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Menu',
      theme: ThemeData(
        primarySwatch: Colors.blue  ,
      ),
      home: SetCalculator(),
    );
  }
}

