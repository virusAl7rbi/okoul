// ignore_for_file: prefer_const_constructors, file_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

Widget FinishDialog(int rightQuestions) => Dialog(
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
