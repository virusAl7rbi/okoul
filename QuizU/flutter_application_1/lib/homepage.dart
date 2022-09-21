// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_application_1/leadboardpage.dart';
import 'package:flutter_application_1/profilepage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

Widget Home() {
  return Center(
    child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      SizedBox(
        height: 250,
      ),
      TextButton(
          onPressed: () {},
          child: Text(
            "Start Quiz",
            style: TextStyle(fontSize: 30),
          ))
    ]),
  );
}

class _HomePageState extends State<HomePage> {
  final List<Widget> _tabItems = [Home(), LeadBoardPage(), ProfilePage()];
  PageController pagecont = PageController();
  int _currentIndex = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Quiz U")),
        automaticallyImplyLeading: false,
      ),
      body: _tabItems[_currentIndex],
      // body: PageView(
      //   controller: pagecont,
      //   children: _tabItems,
      //   onPageChanged: (page) {
      //     setState(() => _currentIndex = page);
      //   },
      // ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: Color(0xFF6200EE),
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.red.withOpacity(.60),
        selectedFontSize: 14,
        unselectedFontSize: 14,
        type: BottomNavigationBarType.shifting,
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
          print(page);
          setState(() => _currentIndex = page);
        },
      ),
    );
  }
}
