// ignore_for_file: prefer_const_constructors, must_be_immutable, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_2/homePage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class Login extends StatelessWidget {
  Login({super.key});
  FlutterSecureStorage storage = FlutterSecureStorage();
  // input felids controller
  TextEditingController phoneNum = TextEditingController();
  TextEditingController otpNum = TextEditingController();
  TextEditingController name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Okoul"),
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
                      border:
                          OutlineInputBorder(borderSide: BorderSide(width: 5))),
                  onChanged: (text) {
                    if (text.startsWith("05")) {}
                  },
                ),
                SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: otpNum,
                  maxLength: 4,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.password),
                      hintText: "otp is 0000",
                      label: Text("OTP"),
                      border:
                          OutlineInputBorder(borderSide: BorderSide(width: 5))),
                ),
                SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                    // check if phone number in DB, if not ask him about his name
                    // check if otp == 0000
                    onPressed: () async {
                      // url: https://quizu.okoul.com/Login -data {"OTP":0000, "mobile":"05"}
                      var url = Uri.parse("https://quizu.okoul.com/Login");
                      var response = await http.post(url,
                          body: {"OTP": otpNum.text, "mobile": phoneNum.text});
                      var body = jsonDecode(response.body);
                      print(body['message'].toString().contains("Token"));
                      print(body);
                      await storage.write(key: "token", value: body['token']);
                      if (body['user_status'] == 'new') {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Do I know you?"),
                                content: SizedBox(
                                  height: 110,
                                  child: Column(children: [
                                    TextField(
                                      controller: name,
                                      decoration:
                                          InputDecoration(label: Text("Name")),
                                    ),
                                    TextButton(
                                        onPressed: () async {
                                          // url: https://quizu.okoul.com/Name | Authorization: token | data: name
                                          String? token =
                                              await storage.read(key: "token");
                                          var url = Uri.parse(
                                              "https://quizu.okoul.com/Name");
                                          await http.post(url, headers: {
                                            "Authorization": token!
                                          }, body: {
                                            "name": name.text
                                          });

                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      HomePage()),
                                              (route) => false);
                                        },
                                        child: Text("Login"))
                                  ]),
                                ),
                              );
                            });
                      } else if (body['message'].toString().contains("Token")) {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                            (route) => false);
                      }
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(fontSize: 20),
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
