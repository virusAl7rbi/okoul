// ignore_for_file: avoid_print, use_build_context_synchronously, prefer_const_constructors
import 'dart:ui';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_2/homePage.dart';
import 'package:flutter_application_2/loginPage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

// Read value

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void checkUser() async {
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    if (token != null) {
      var url = Uri.parse("https://quizu.okoul.com/Token");
      var response = await http.get(url, headers: {"Authorization": token});
      var res = jsonDecode(response.body);
      if (res['success'] == true) {
        print(body);
        setState(() {
          body = HomePage();
        });
      }
    } else {
      setState(() {
        body = LoginPage();
      });
    }
  }

  Widget body = Scaffold(
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
  );
  @override
  initState() {
    super.initState();
    checkUser();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.light(
            background: Color.fromARGB(1, 30, 189, 186),
            brightness: Brightness.light,
            error: Colors.red,
            onBackground: Color.fromARGB(1, 146, 212, 212),
            onError: Colors.red,
            // onPrimary: Color.fromARGB(1, 30, 189, 186),
            onSecondary: Color.fromARGB(1, 100, 206, 201)),
        inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(),
            labelStyle: TextStyle(
              fontSize: 15,
            )),
      ),
      home: SafeArea(child: body),
    );
  }
}
