// ignore_for_file: prefer_const_constructors,, non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:quizu/view/homeWIdget.dart';
import 'package:quizu/view/quizWidget.dart';

WrongDialog(context) => Dialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: SizedBox(
            height: 200,
            width: 400,
            child: Column(
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
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()),
                              (route) => false);
                        },
                        child: Text("Retry"))),
              ],
            )),
      ),
    );
