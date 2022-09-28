// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:quizu/services/apiService.dart';
import 'package:quizu/view/homeWidget.dart';
import 'package:quizu/view/loginWidget.dart';

class LandingPageController extends GetxController {
  // initialize api
  ApiClient api = ApiClient();
  // initialize local storage
  FlutterSecureStorage storage = FlutterSecureStorage();
  // set navigator point

  Widget page = LoginPage();
  LandingPageController(context) {
    tokenChecker(context);
  }
  tokenChecker(context) async {
    if (await storage.read(key: "token") != null) {
     await api.tokenValidation().then((value) {
        page = value.success ? HomePage() : LoginPage();
        
      });
    } else {
      page = LoginPage();
    }
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => page,
        ),
        (route) => false);
  }
}
