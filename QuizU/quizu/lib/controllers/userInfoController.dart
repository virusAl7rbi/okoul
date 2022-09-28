// ignore_for_file: prefer_const_constructors, duplicate_ignore

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:quizu/services/apiService.dart';
import 'package:quizu/view/loginWidget.dart';

class UserInfoController extends GetxController {
  // set global style for user info
  // ignore: prefer_const_constructors
  TextStyle userStyle = TextStyle(
    fontSize: 18,
  );
  UserInfoController() {
    getUserInfo();
  }
  // initialize api
  ApiClient api = ApiClient();
  // initialize local storage
  FlutterSecureStorage storage = FlutterSecureStorage();
  // previous score
  List prevScore = [
    {"date": "2022/09/28 12:30pm", "score": "30"}
  ];
  String name = "";
  String mobile = "";

  getUserInfo() {
    api.userInfo().then((value) {
      name = value.name;
      mobile = value.mobile;
      update();
    });
  }

  Future getPrevScore() async {
    storage.read(key: "score").then((value) {
      prevScore = jsonDecode(value!);
      update();
    });
  }

  logout(context) async {
    await storage.deleteAll();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
        (route) => false);
  }
}
