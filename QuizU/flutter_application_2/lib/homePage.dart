// ignore_for_file: file_names, prefer_const_constructors_in_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_application_2/Quiz.dart';
import 'package:flutter_application_2/leadboardPage.dart';
import 'package:flutter_application_2/profilePage.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> _tabItems = [Quiz(), LeadBoardPage(), ProfilePage()];
  PageController pageCont = PageController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Center(
            child: Text("QuizU ⏳"),
          )),
      body: _tabItems[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: Color.fromARGB(1, 30, 189, 186).withOpacity(1),
        selectedItemColor: Color.fromARGB(1, 100, 206, 201).withOpacity(1),
        unselectedItemColor: Colors.red.withOpacity(.60),
        selectedFontSize: 14,
        unselectedFontSize: 14,
        type: BottomNavigationBarType.shifting,
        // ignore: prefer_const_literals_to_create_immutables
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.leaderboard_rounded), label: "LeadBoard"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_outlined), label: "Profile")
        ],
        onTap: (page) {
          setState(() => _currentIndex = page);
        },
      ),
    );
  }
}
