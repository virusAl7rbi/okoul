// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:quizu/controllers/landingPageController.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LandingPageController>(
      init: LandingPageController(context),
      builder: ((controller) => Scaffold(
            body: Container(
              decoration: BoxDecoration(),
              alignment: Alignment.center,
              // ignore: prefer_const_literals_to_create_immutables
              child: ListView(shrinkWrap: true, children: [
                Center(
                  child: Text(
                    "QuizU ⏳",
                    style: TextStyle(fontSize: 50),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: CircularProgressIndicator(),
                )
              ]),
            ),
          )),
    );
  }
}
