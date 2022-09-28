// ignore_for_file: unused_import, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:quizu/view/leadBoardWidget.dart';
import 'package:quizu/view/quizWidget.dart';
import 'package:quizu/view/userInfoWidget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int pageIndex = 0;
  final List widgets = [QuizPage(), LeadBoardPage(), UserInfoPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QuizU"),
        centerTitle: true,
      ),
      body: widgets[pageIndex],
      // ignore: prefer_const_literals_to_create_immutables
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: pageIndex,
        selectedFontSize: 16,
        showUnselectedLabels: false,
        // ignore: prefer_const_literals_to_create_immutables
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.quiz_rounded), label: "Quiz"),
          BottomNavigationBarItem(
              icon: Icon(Icons.leaderboard_rounded), label: "LeadBoard"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile")
        ],
        onTap: ((index) => setState(() {
              pageIndex = index;
            })),
      ),
    );
  }
}
