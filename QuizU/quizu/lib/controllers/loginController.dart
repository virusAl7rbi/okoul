// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables, avoid_init_to_null, unnecessary_null_comparison

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:phone_number/phone_number.dart';
import 'package:quizu/services/apiService.dart';
import 'package:quizu/view/homeWidget.dart';

class LoginController extends GetxController {
  // call api class
  ApiClient api = ApiClient();

  // local storage
  FlutterSecureStorage storage = FlutterSecureStorage();
  // login controller
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController otp = TextEditingController();
  TextEditingController name = TextEditingController();

  

  // errorText value
  var phoneError = null;
  var otpError = null;
  // validate phone number
  bool isPhoneValid = false;
  formValidate() async {
    // phone number validation
    if (phoneNumber.text.length > 10) {
      phoneError = "To short";
    } else if (phoneNumber.text.isEmpty) {
      phoneError = "Can't be empty";
    } else {
      RegionInfo region =
          RegionInfo(prefix: 05, code: 'SA', name: 'SaudiArabia');
      // Validate

      await PhoneNumberUtil()
          .validate(phoneNumber.text, regionCode: region.code)
          .then((value) => isPhoneValid = value);

      if (isPhoneValid == false) {
        phoneError = "phone number should be start with \"05\"";
      }
      phoneError = null;
    }
    // opt validation
    if (otp.isBlank == true) {
      otpError = "Can't be empty";
    } else if (otp.text.length > 4) {
      otpError = "To short";
    } else if (otp.text != "0000") {
      otpError = "should be 0000";
    } else {
      otpError = null;
    }
  }

  login(context) async {
    await formValidate();

    if (phoneError != null || otpError != null || isPhoneValid == false) {
      update();
    } else {
      printInfo(info: "${phoneNumber.text}, ${phoneNumber.text.runtimeType}");
      api.login(phoneNumber.text, otp.text).then((res) {
        if (res != null) {
          storage.write(key: "token", value: res.token);
          if (res.message.contains("new")) {
            // show add name dialog
          } else {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => HomePage(),
                ),
                (route) => false);
          }
        }
      });
    }
  }
}
