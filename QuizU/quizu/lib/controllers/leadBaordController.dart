// ignore_for_file: prefer_const_constructors
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:quizu/models/topUsersModel.dart';
import 'package:quizu/services/apiService.dart';

class LeadBoardController extends GetxController {
  // initialize api
  ApiClient api = ApiClient();
  // users list
  List topUsers = [];
  // global text style for top users score
  TextStyle userStyle = TextStyle(
    fontSize: 15,
  );

  LeadBoardController() {
    getTopUsers();
  }
  getTopUsers() async {
    await api.Top10().then((value) => topUsers = value);
    update();
  }
}
