// ignore_for_file: avoid_print, use_build_context_synchronously

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

bool isUserLogged = false;

class _MyAppState extends State<MyApp> {
  void checkUser() async {
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    if (token != null) {
      var url = Uri.parse("https://quizu.okoul.com/Token");
      var response = await http.get(url, headers: {"Authorization": token});
      var body = jsonDecode(response.body);
      print(body);
      if (body['success'] == true) {
        print(body);
        setState(() {
          isUserLogged = true;
        });
      }
    }
  }

  @override
  initState() {
    super.initState();
    checkUser();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(child: isUserLogged ? HomePage() : Login()),
    );
  }
}
