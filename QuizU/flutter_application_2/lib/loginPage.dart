// ignore_for_file: prefer_const_constructors, must_be_immutable, use_build_context_synchronously, unnecessary_null_comparison

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_2/homePage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:phone_number/phone_number.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FlutterSecureStorage storage = FlutterSecureStorage();

  //global key
  final _formKey = GlobalKey<FormState>();

  // input felids controller
  TextEditingController phoneNum = TextEditingController();
  TextEditingController otpNum = TextEditingController();
  TextEditingController name = TextEditingController();
  // to validate phone field
  dynamic phoneValidation = null;

  Future<String?> phoneValidator(String phoneNum) async {
    String phone = phoneNum;
    RegionInfo region = RegionInfo(prefix: 05, code: 'SA', name: 'SaudiArabia');
    bool isValid =
        await PhoneNumberUtil().validate(phone, regionCode: region.code);
    return isValid ? null : "phone number should start with 05";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text("Okoul")),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 30,
          ),
          Center(
              child: Text(
            "Log in",
            style: TextStyle(fontSize: 40),
          )),
          Padding(
              padding:
                  EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 40),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      validator: ((value) {
                        if (value!.isEmpty) return "shouldn't be empty";
                        if (value.length > 10) return "It's to short";

                        return phoneValidation;
                      }),
                      controller: phoneNum,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.phone),
                          hintText: "05xxxxxxxx",
                          label: Text("Phone number"),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(width: 5))),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) return "Can't be empty";
                        if (value.length > 10) return "to Short";
                        if (value != "0000") return "OTP should be 0000";
                        return null;
                      },
                      controller: otpNum,
                      maxLength: 4,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.password),
                          hintText: "otp is 0000",
                          label: Text("OTP"),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(width: 5))),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                        // check if phone number in DB, if not ask him about his name
                        // check if otp == 0000
                        onPressed: () async {
                          final check = await phoneValidator(phoneNum.text);
                          setState(() => phoneValidation = check);
                          print(check);
                          if (_formKey.currentState!.validate()) {
                            // If the form is valid, display a Snackbar.
// url: https://quizu.okoul.com/Login -data {"OTP":0000, "mobile":"05"}
                            var url =
                                Uri.parse("https://quizu.okoul.com/Login");
                            var response = await http.post(url, body: {
                              "OTP": otpNum.text,
                              "mobile": phoneNum.text
                            });
                            var body = jsonDecode(response.body);
                            await storage.write(
                                key: "token", value: body['token']);
                            if (body['user_status'] == 'new') {
                              newUser();
                            } else if (body['message']
                                .toString()
                                .contains("Token")) {
                              // navigate to home page (one way)
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomePage()),
                                  (route) => false);
                            }
                          }
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 20,
                            height: 2 / 3,
                          ),
                        ))
                  ],
                ),
              ))
        ],
      ),
    );
  }

  Future newUser() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Do I know you?"),
            content: SizedBox(
              height: 120,
              child: Column(children: [
                TextField(
                  controller: name,
                  decoration: InputDecoration(label: Text("Name")),
                ),
                SizedBox(
                  height: 10,
                ),
                TextButton(
                    onPressed: () async {
                      // url: https://quizu.okoul.com/Name | Authorization: token | data: name
                      String? token = await storage.read(key: "token");
                      var url = Uri.parse("https://quizu.okoul.com/Name");
                      await http.post(url,
                          headers: {"Authorization": token!},
                          body: {"name": name.text});

                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                          (route) => false);
                    },
                    child: Text(
                      "Now you know me",
                      style: TextStyle(fontSize: 15),
                    ))
              ]),
            ),
          );
        });
    ;
  }
}
