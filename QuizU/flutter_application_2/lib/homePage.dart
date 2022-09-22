// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, prefer_const_constructors_in_immutables, file_names

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/leadboardPage.dart';
import 'package:flutter_application_2/profilePage.dart';
import 'package:flutter_application_2/quizDIalog.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> _tabItems = [Home(), LeadBoardPage(), ProfilePage()];
  PageController pageCont = PageController();
  int _currentIndex = 0;

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

class _HomeState extends State<Home> with TickerProviderStateMixin {
  // timer controller
  late AnimationController controller;

  // quiz vars
  List questions = <Object>[];
  int rightAnswer = 0;
  int questionIndex = 0;

  // timer display
  String get countdownText {
    Duration count = controller.duration! * controller.value;
    return "${(count.inMinutes % 60).toString().padLeft(2, '0')}:${(count.inSeconds % 60).toString().padLeft(2, '0')}";
  }

  getQuestions() async {
// https://quizu.okoul.com/Questions
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    var url = Uri.parse("https://quizu.okoul.com/Questions");
    var response = await http.get(url, headers: {"Authorization": token!});
    if (response.statusCode == 200) {
      // print(response.body);
      List body = jsonDecode(response.body);
      setState(() {
        questions = body;
      });
    }
  }

  startQuiz() {
    controller.reverse(from: controller.value == 0 ? 1.0 : controller.value);
    ShowQuizDialog(context);
  }

  quizAction() {
    if (questions[questionIndex]['correct'] == 'd') {
      questionIndex++;
      rightAnswer++;
    } else {
      controller.reset();
      rightAnswer = 0;
      questionIndex = 0;
      Navigator.pop(context);
      showDialog(context: context, builder: (context) => WrongDialog());
    }
  }

  @override
  void initState() {
    super.initState();
    getQuestions();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 120));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: TextButton(
      onPressed: () => startQuiz(),
      child: Text(
        "Start the Quiz U",
        style: TextStyle(fontSize: 30),
      ),
    ));
  }

  Future<void> ShowQuizDialog(
    BuildContext context,
  ) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: ((context, setState) {
            return Dialog(
              child: SizedBox(
                height: 475,
                width: 400,
                // ignore: prefer_const_literals_to_create_immutables
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      // Timer
                      Center(
                        child: AnimatedBuilder(
                            animation: controller,
                            builder: ((context, child) => Text(
                                  countdownText,
                                  style: TextStyle(fontSize: 40),
                                ))),
                      ),
                      // End timer
                      Divider(
                        thickness: 3,
                      ),
                      SizedBox(
                        height: 0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          questions[questionIndex]['Question'],
                          style: TextStyle(fontSize: 30),
                        ),
                      ),
                      SizedBox(
                        height: 45,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                  onPressed: () => quizAction(),
                                  child: Text(
                                    questions[questionIndex]['a'],
                                    style: TextStyle(fontSize: 15),
                                  )),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                  onPressed: () => quizAction(),
                                  child: Text(
                                    questions[questionIndex]['b'],
                                    style: TextStyle(fontSize: 15),
                                  )),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                  onPressed: () => quizAction(),
                                  child: Text(
                                    questions[questionIndex]['c'],
                                    style: TextStyle(fontSize: 15),
                                  )),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                  onPressed: () => quizAction(),
                                  child: Text(
                                    questions[questionIndex]['d'],
                                    style: TextStyle(fontSize: 15),
                                  )),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                questionIndex++;
                              });
                            },
                            child: Text(
                              "Skip",
                              style: TextStyle(fontSize: 15),
                            )),
                      )
                    ]),
              ),
            );
          }));
        });
  }
}
