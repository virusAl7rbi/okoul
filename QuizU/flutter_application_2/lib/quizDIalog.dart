// ignore_for_file: non_constant_identifier_names, prefer_const_constructors, file_names
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

Widget WrongDialog() {
  return Dialog(
    // ignore: prefer_const_literals_to_create_immutables
    child: SizedBox(
        height: 200,
        width: 400,
        child: Column(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            SizedBox(
              height: 15,
            ),
            Text("😢", style: TextStyle(fontSize: 50)),
            Text(
              "Wrong answer",
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(
              height: 55,
            ),
            ElevatedButton(onPressed: () {}, child: Text("Retry"))
          ],
        )),
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
