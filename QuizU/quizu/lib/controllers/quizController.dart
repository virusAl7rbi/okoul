// ignore_for_file: non_constant_identifier_names, prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:quizu/services/apiService.dart';
import 'package:quizu/view/dialogs/beforeTimeDialog.dart';
import 'package:quizu/view/dialogs/wrongDialog.dart';
import 'package:quizu/view/quizWidget.dart';

import '../models/questuionsModel.dart';

class QuizController extends GetxController {
  QuizController() {
    getQuestions();
  }

//storage
  FlutterSecureStorage storage = FlutterSecureStorage();
  ApiClient api = ApiClient();

  // quiz vars
  List questions = <Questions>[];
  int rightAnswer = 0;
  int questionIndex = 0;
  bool skipUsed = false;

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

  durationToString(int seconds) {
    Duration time = Duration(seconds: seconds);
    return "${(time.inMinutes % 60).toString().padLeft(2, '0')}:${(time.inSeconds % 60).toString().padLeft(2, '0')}";
  }

  startQuizTimer() {}

  quizAction(String answer, BuildContext context) async {
    if (questions[questionIndex].correct == answer) {
      if (questionIndex < 29) {
        questionIndex++;
        rightAnswer++;
        return true;
      } else {
        // countdownText
        Navigator.pop(context);

        // get time deference
        var timeInSec;
        var diff = (timeInSec - 121).abs();
        showDialog(
            context: context,
            builder: (context) =>
                BeforeTime(durationToString(diff), rightAnswer));

        // save record locally
        await api.newScore(rightAnswer);
        rightAnswer = 0;
        questionIndex = 0;
        skipUsed = false;
        return true;
      }
    } else {
      rightAnswer = 0;
      questionIndex = 0;
      skipUsed = false;
      Navigator.pop(context);
      showDialog(context: context, builder: (context) => WrongDialog(context));
    }
  }

  getQuestions() async {
    await api.getQuestions().then((value) => questions = value);
  }
}
