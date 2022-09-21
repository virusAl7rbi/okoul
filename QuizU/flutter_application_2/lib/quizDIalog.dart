// ignore_for_file: non_constant_identifier_names, prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

Widget Wrong() {
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
            Text(
              "Wrong answer 😢",
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

Widget Wright(int rightQuestions) {
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

Widget Quiz(
    {required String question,
    required List<String> answers,
    required int rightAnswer,
    required var timer}) {
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
          "$timer",
          style: TextStyle(fontSize: 40),
        ),
        Divider(
          thickness: 3,
        ),
        SizedBox(
          height: 0,
        ),
        Text(
          question,
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
                  answers[0],
                  style: TextStyle(fontSize: 15),
                )),
            ElevatedButton(
                onPressed: () {},
                child: Text(
                  answers[1],
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
                  answers[2],
                  style: TextStyle(fontSize: 15),
                )),
            ElevatedButton(
                onPressed: () {},
                child: Text(
                  answers[3],
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
}
