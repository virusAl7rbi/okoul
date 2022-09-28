// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizu/controllers/quizController.dart';
import 'package:quizu/view/homeWIdget.dart';
import 'package:quizu/view/quizContainer.dart';

class QuizPage extends StatelessWidget {
  const QuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          // ignore: prefer_const_literals_to_create_immutables
          children: [
            Text(
              "Lit's test your knowledge",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 20,
            ),
            GetBuilder<QuizController>(
              init: QuizController(),
              builder: ((controller) => ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => QuizContainer()),
                        (route) => false);
                  },
                  icon: Icon(Icons.quiz_rounded),
                  label: Text("Test me"))),
            )
          ],
        ),
      ),
    );
  }
}
