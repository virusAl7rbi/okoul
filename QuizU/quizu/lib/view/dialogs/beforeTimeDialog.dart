// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

Widget BeforeTime(String time, rightQuestions) => Dialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: SizedBox(
          child: Column(
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
                onPressed: () {
                     Share.share(
                    "I answered $rightQuestions correct answers in QuizU!");
              },
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
