import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Quiz extends StatefulWidget {
  Quiz({super.key});

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> with TickerProviderStateMixin {
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
  bool skipUsed = false;

  // timer display
  String get countdownText {
    Duration count = controller.duration! * controller.value;
    return "${(count.inMinutes % 60).toString().padLeft(2, '0')}:${(count.inSeconds % 60).toString().padLeft(2, '0')}";
  }

  String durationToString(duration) {
    return "${(duration.inMinutes % 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}";
  }

  getQuestions() async {
// https://quizu.okoul.com/Questions
    String? token = await storage.read(key: "token");
    var url = Uri.parse("https://quizu.okoul.com/Questions");
    var response = await http.get(url, headers: {"Authorization": token!});
    if (response.statusCode == 200) {
      // print(response.body);
      List body = jsonDecode(response.body);
      if (mounted) {
        setState(() {
          questions = body;
        });
      }
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
      if (questionIndex < 29) {
        setState(() {
          questionIndex++;
          rightAnswer++;
        });
        return true;
      } else {
        // countdownText
        Navigator.pop(context);
        controller.stop;
        // get time deference
        var diff = Duration(
            seconds: ((controller.duration! * controller.value).inSeconds - 121)
                .abs());
        showDialog(
            context: context,
            builder: (context) => BeforeTime(durationToString(diff)));

        // save record locally
        addRecord();
        rightAnswer = 0;
        questionIndex = 0;
        skipUsed = false;
        return true;
      }
    } else {
      controller.stop;
      rightAnswer = 0;
      questionIndex = 0;
      skipUsed = false;
      Navigator.pop(context);
      showDialog(context: context, builder: (context) => WrongDialog());
    }
  }

  to12(int time) {
    if (time > 12) {
      return (time - 12).abs();
    } else {
      return time;
    }
  }

  getTime() {
    DateTime now = DateTime.now();
    String period = TimeOfDay(hour: now.hour, minute: now.minute)
        .period
        .toString()
        .split(".")[1];

    return "${now.day}/${now.month}/${now.year}   ${to12(now.hour)}:${now.minute}$period";
  }

  addRecord() async {
    final storage = FlutterSecureStorage();
    // send add score post
    var url = Uri.parse("https://quizu.okoul.com/Score");
    String? token = await storage.read(key: "token");
    var response = await http.post(url,
        headers: {"Authorization": token!},
        body: json.encode({"score": rightAnswer}));

    String time = getTime();
    int answers = rightAnswer;
    List record = <Object>[];
    record.add({"date": time, "score": answers});
    String? storedRecord = await storage.read(key: "record");
    if (storedRecord == null) {
      await storage.write(key: "record", value: jsonEncode(record));
    } else {
      List oldRecord = jsonDecode(storedRecord);
      List newRecord = oldRecord + record;
      await storage.write(key: "record", value: jsonEncode(newRecord));
    }
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this);
    getQuestions();

    // check on timer
    // controller.forward().whenComplete(() {});
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
              insetPadding: EdgeInsets.zero,
              child: SizedBox(
                height: 500,
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
                                      if (quizAction('a', context)) {
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
                                          if (quizAction('b', context))
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
                                          if (quizAction('c', context))
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
                                          if (quizAction('d', context))
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
                              if (skipUsed == false) {
                                setState(() {
                                  questionIndex++;
                                  skipUsed = true;
                                });
                              }
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
                        onPressed: () {
                          Navigator.pop(context);
                          startQuizTimer();
                        },
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

Widget BeforeTime(String time) {
  return Dialog(
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        // ignore: sort_child_properties_last
        child: Column(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            SizedBox(
              height: 5,
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
              "30",
              style: TextStyle(fontSize: 40),
            ),
            Text(
              "Correct answer!\n",
              style: TextStyle(fontSize: 20),
            ),
            Text(
              "in",
              style: TextStyle(fontSize: 35),
            ),
            Text(
              time,
              style: TextStyle(fontSize: 35),
            ),
            ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.share),
              label: Text("Share"),
            )
          ],
        ),
        height: 380,
        width: 400,
      ),
    ),
  );
}
