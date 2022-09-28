// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:quizu/view/landingWidget.dart';
import 'package:quizu/view/quizContainer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LandingPage(),
    );
  }
}
