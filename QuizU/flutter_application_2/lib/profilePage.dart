// ignore_for_file: prefer_const_constructors, unused_local_variable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_2/loginPage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = "";
  String phoneNumber = "";
  List scores = [];

  getData() async {
    // get token from storage
    var storage = FlutterSecureStorage();
    String? token = await storage.read(key: "token");

    // get user info by api
    var url = Uri.parse("https://quizu.okoul.com/UserInfo");
    var response = await http.get(url, headers: {"Authorization": token!});
    String? storedRecord = await storage.read(key: "record");
    print(storedRecord);
    // set info to variable from api
    var body = jsonDecode(response.body);
    setState(() {
      name = body['name'].toString();
      phoneNumber = body['mobile'].toString();
      if (storedRecord != null) {
        // scores = jsonDecode(storedRecord);
        scores = [
          {"date": " 3:9pm  2022/9/24", "score": 1}
        ];
        print(scores);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 0, top: 80),
      child: Column(
        children: [
          Text(
            "Profile",
            style: TextStyle(fontSize: 40),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 0, top: 35),
                child: Container(
                  padding: EdgeInsets.all(20),
                  height: 250,
                  width: 350,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5), //color of shadow
                          spreadRadius: 5, //spread radius
                          blurRadius: 7, // blur radius
                          offset:
                              const Offset(0, 2), // changes position of shadow
                        ),
                        //you can set more BoxShadow() here
                      ],
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      Text("Name: $name"),
                      Text("Phone number: $phoneNumber"),
                      SizedBox(
                        height: 20,
                      ),
                      Divider(
                        thickness: 3,
                      ),
                      Center(
                        child: Text(
                          "My Score",
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 250,
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(scores[index]["date"]),
                                  Text('${scores[index]["score"]}')
                                ],
                              );
                            },
                            itemCount: scores.length,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: (() async {
                const storage = FlutterSecureStorage();
                await storage.deleteAll();
                // ignore: use_build_context_synchronously
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                    (route) => false);
              }),
              child: Text("Log out"))
        ],
      ),
    );
  }
}
