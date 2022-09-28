// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, non_constant_identifier_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizu/controllers/quizController.dart';

class QuizContainer extends StatefulWidget {
  QuizContainer({super.key});

  @override
  State<QuizContainer> createState() => _QuizContainerState();
}

class _QuizContainerState extends State<QuizContainer> {
  late Timer timer;
  int timeInSec = 121;
  void StateTimerStart() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeInSec > 0) {
        setState(() {
          timeInSec--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(automaticallyImplyLeading: true, actions: [
          IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(Icons.arrow_back_ios_new_rounded))
        ]),
        body: SafeArea(
          child: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: IntrinsicHeight(
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.grey.withOpacity(0.5), //color of shadow
                            spreadRadius: 5, //spread radius
                            blurRadius: 7, // blur radius
                            offset: const Offset(
                                0, 2), // changes position of shadow
                          ),
                          //you can set more BoxShadow() here
                        ],
                        borderRadius: BorderRadius.circular(10)),
                    child: GetBuilder<QuizController>(
                      init: QuizController(),
                      builder: ((controller) {
                        StateTimerStart();
                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 15,
                              ),
                              // Timer
                              Center(
                                  child: Text(
                                controller.durationToString(timeInSec),
                                style: TextStyle(fontSize: 40),
                              )),
                              // End timer
                              Divider(
                                thickness: 3,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Text(
                                  controller.questions[controller.questionIndex]
                                      .question,
                                  style: TextStyle(fontSize: 30),
                                ),
                              ),
                              SizedBox(
                                height: 45,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Column(
                                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                            onPressed: () {
                                              controller.quizAction(
                                                  "a", context);
                                            },
                                            child: Text(
                                              controller
                                                  .questions[
                                                      controller.questionIndex]
                                                  .a,
                                              style: TextStyle(fontSize: 15),
                                            )),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                            onPressed: () {
                                              controller.quizAction(
                                                  "b", context);
                                            },
                                            child: Text(
                                              controller
                                                  .questions[
                                                      controller.questionIndex]
                                                  .b,
                                              style: TextStyle(fontSize: 15),
                                            )),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                            onPressed: () => controller
                                                .quizAction("c", context),
                                            child: Text(
                                              controller
                                                  .questions[
                                                      controller.questionIndex]
                                                  .c,
                                              style: TextStyle(fontSize: 15),
                                            )),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                            onPressed: () => controller
                                                .quizAction("d", context),
                                            child: Text(
                                              controller
                                                  .questions[
                                                      controller.questionIndex]
                                                  .d,
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
                                      if (controller.skipUsed == false) {
                                        controller.questionIndex++;
                                        controller.skipUsed = true;
                                        controller.update();
                                      }
                                    },
                                    child: Text(
                                      "Skip",
                                      style: TextStyle(fontSize: 15),
                                    )),
                              ),
                              SizedBox(
                                height: 15,
                              )
                            ]);
                      }),
                    )),
              ),
            ),
          ),
        ));
  }
}
