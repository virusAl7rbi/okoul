// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, prefer_const_constructors_in_immutables, file_names, unused_local_variable

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/leadboardPage.dart';
import 'package:flutter_application_2/profilePage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

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
  // timer vars
  Timer? timer;
  late AnimationController controller;
  int timeInSec = 121;
  //storage
  var storage = FlutterSecureStorage();
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

  startQuizTimer() {
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: timeInSec))
          ..repeat();
    controller.reverse(
        from: controller.value == 0
            ? 1.0
            : controller.value); // to start from 2:00 and countdown
    ShowQuizDialog(context);
  }

  postScore(int score) async {
    String? token = await storage.read(key: "token");
    var url = Uri.parse("https://quizu.okoul.com/Score");
    var response = http
        .post(url, headers: {"Authorization": token!}, body: {"score": score});
  }

  quizAction(String answer, BuildContext context) {
    if (questions[questionIndex]['correct'] == answer) {
      setState(() {
        questionIndex++;
        rightAnswer++;
      });
      return (true);
    } else {
      controller.stop;
      rightAnswer = 0;
      questionIndex = 0;
      Navigator.pop(context);
      showDialog(context: context, builder: (context) => WrongDialog());
    }
  }

  getTime() {
    DateTime now = DateTime.now();
    String period = TimeOfDay(hour: now.hour, minute: now.minute)
        .period
        .toString()
        .split(".")[1];
    return "${now.hour - 12}:${now.minute}$period  ${now.year}/${now.month}/${now.day}";
  }

  addRecord() async {
    String time = getTime();
    int answers = rightAnswer;
    List record = <Object>[];
    record.add({"date": time, "score": answers});
    final storage = FlutterSecureStorage();
    String? storedRecord = await storage.read(key: "record");
    if (storedRecord == null) {
      await storage.write(key: "record", value: record.toString());
    } else {
      List oldRecord = jsonDecode(storedRecord);
      List newRecord = oldRecord + record;
      await storage.write(key: "record", value: newRecord.toString());
      print(newRecord);
    }
  }

  @override
  void initState() {
    super.initState();
    getQuestions();

    // set timer duration
    controller = AnimationController(
        vsync: this, duration: Duration(seconds: timeInSec));
    // check on timer
    controller.forward().whenComplete(() {});
    controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        // dismiss quiz dialog and show timeout dialog ==> FinishDialog()
        Navigator.pop(context);
        showDialog(
            context: context, builder: (context) => FinishDialog(rightAnswer));
        // save record
        addRecord();
      }
    });
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
      onPressed: () => startQuizTimer(),
      child: Text(
        "Start the Quiz U",
        style: TextStyle(fontSize: 30),
      ),
    ));
  }

  Future<void> ShowQuizDialog(BuildContext context) async {
    return await showDialog(
        barrierDismissible: false,
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
                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                    onPressed: () {
                                      if (quizAction('a', context) == true) {
                                        setState(() {});
                                      }
                                    },
                                    child: Text(
                                      questions[questionIndex]['a'],
                                      style: TextStyle(fontSize: 15),
                                    )),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                    onPressed: () => {
                                          if (quizAction('b', context) == true)
                                            {setState(() {})}
                                        },
                                    child: Text(
                                      questions[questionIndex]['b'],
                                      style: TextStyle(fontSize: 15),
                                    )),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                    onPressed: () => {
                                          if (quizAction('c', context) == true)
                                            {setState(() {})}
                                        },
                                    child: Text(
                                      questions[questionIndex]['c'],
                                      style: TextStyle(fontSize: 15),
                                    )),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                    onPressed: () => {
                                          if (quizAction('d', context) == true)
                                            {setState(() {})}
                                        },
                                    child: Text(
                                      questions[questionIndex]['d'],
                                      style: TextStyle(fontSize: 15),
                                    )),
                              ),
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

  Widget WrongDialog() {
    return Dialog(
      // ignore: prefer_const_literals_to_create_immutables
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: SizedBox(
            height: 200,
            width: 400,
            child: Column(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                Text("😢", style: TextStyle(fontSize: 50)),
                Text(
                  "Wrong answer",
                  style: TextStyle(fontSize: 30),
                ),
                SizedBox(
                  height: 55,
                ),
                Expanded(
                    child: ElevatedButton(
                        onPressed: () => startQuizTimer(),
                        child: Text("Retry"))),
              ],
            )),
      ),
      // SizedBox(
      //   height: 20,
      // )
    );
  }

  Widget FinishDialog(int rightQuestions) {
    return Dialog(
      child: SizedBox(
        // ignore: sort_child_properties_last
        child: Column(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            SizedBox(
              height: 35,
            ),
            Text(
              "🏁",
              style: TextStyle(fontSize: 80),
            ),
            Text(
              "\nYou have completed",
              style: TextStyle(fontSize: 20),
            ),
            Text(
              "$rightQuestions",
              style: TextStyle(fontSize: 40),
            ),
            Text(
              "Correct answer!\n",
              style: TextStyle(fontSize: 20),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Share.share(
                    "I answered $rightQuestions correct answers in QuizU!");
              },
              icon: Icon(Icons.share),
              label: Text("Share"),
            )
          ],
        ),
        height: 350,
        width: 400,
      ),
    );
  }
}
