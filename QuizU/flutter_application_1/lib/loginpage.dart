// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/homepage.dart';
import 'firebase_options.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController phoneNum = TextEditingController();

  TextEditingController otpNum = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Okoul"),
      ),
      body: ListView(
        children: [
          Text("Log in"),
          Padding(
            padding: EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 40),
            child: Column(
              children: [
                TextField(
                  controller: phoneNum,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.phone),
                    hintText: "05xxxxxxxx",
                    label: Text("Phone number"),
                  ),
                  onChanged: (text) {
                    if (text.startsWith("05")) {}
                  },
                ),
                TextField(
                  controller: otpNum,
                  maxLength: 4,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(),
                ),
                ElevatedButton(
                    onPressed: () {
                      // check if phone number in DB, if not ask him about his name
                      // check if otp == 0000
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Do I know you?"),
                              content: SizedBox(
                                height: 110,
                                child: Column(children: [
                                  TextField(
                                    decoration:
                                        InputDecoration(label: Text("Name")),
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    HomePage()));
                                      },
                                      child: Text("Login"))
                                ]),
                              ),
                            );
                          });
                    },
                    child: Text("Login"))
              ],
            ),
          )
        ],
      ),
    );
  }
}
