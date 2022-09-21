// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, prefer_const_constructors_in_immutables

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_2/leadboardPage.dart';
import 'package:flutter_application_2/profilePage.dart';
import 'package:flutter_application_2/quizDIalog.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> _tabItems = [Home(), LeadBoardPage(), ProfilePage()];
  PageController pagecont = PageController();
  int _currentIndex = 0;

  // quiz vars
  int rightAnswers = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Center(
            child: Text("Quiz U"),
          )),
      body: _tabItems[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: Color(0xFF6200EE),
        selectedItemColor: Colors.red,
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

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
// timer vars
  Timer? timer;
  int second = 120;
  String? minutes;
  startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        second = second--;
        minutes = Duration(seconds: second).toString().split(".")[0];
        print(minutes);
      });
      if (second > 0) {}
      timer?.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      TextButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                startTimer();
                //   return Quiz(
                //       question: "",
                //       answers: ["", "", "", ""],
                //       rightAnswer: 0,
                //       timer: minutes);
                return Dialog(
                  child: SizedBox(
                    height: 400,
                    width: 400,
                    // ignore: prefer_const_literals_to_create_immutables
                    child: Column(children: [
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "$minutes",
                        style: TextStyle(fontSize: 40),
                      ),
                      Divider(
                        thickness: 3,
                      ),
                      SizedBox(
                        height: 0,
                      ),
                      Text(
                        "question",
                        style: TextStyle(fontSize: 30),
                      ),
                      SizedBox(
                        height: 45,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                              onPressed: () {},
                              child: Text(
                                "answers[0]",
                                style: TextStyle(fontSize: 15),
                              )),
                          ElevatedButton(
                              onPressed: () {},
                              child: Text(
                                "answers[1]",
                                style: TextStyle(fontSize: 15),
                              ))
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                              onPressed: () {},
                              child: Text(
                                "answers[2]",
                                style: TextStyle(fontSize: 15),
                              )),
                          ElevatedButton(
                              onPressed: () {},
                              child: Text(
                                "answers[3]",
                                style: TextStyle(fontSize: 15),
                              ))
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          onPressed: () {},
                          child: Text(
                            "Skip",
                            style: TextStyle(fontSize: 15),
                          ))
                    ]),
                  ),
                );
              });
        },
        child: Text(
          "Start the Quiz U",
          style: TextStyle(fontSize: 30),
        ),
      )
    ]));
  }
}
