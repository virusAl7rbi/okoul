// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizu/controllers/loginController.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QuizU"),
        centerTitle: true,
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: GetBuilder<LoginController>(
              init: LoginController(),
              builder: ((controller) => Column(
                    children: [
                      Text(
                        "Login",
                        style: TextStyle(fontSize: 40),
                      ),
                      TextField(
                        controller: controller.phoneNumber,
                        maxLength: 10,
                        decoration:
                            InputDecoration(errorText: controller.phoneError),
                      ),
                      TextField(
                        controller: controller.otp,
                        maxLength: 4,
                        decoration:
                            InputDecoration(errorText: controller.otpError),
                      ),
                      ElevatedButton.icon(
                          onPressed: () {
                            controller.login(context);
                          },
                          icon: Icon(Icons.login_rounded),
                          label: Text("Login"))
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
