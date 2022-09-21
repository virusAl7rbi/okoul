// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class LeadBoardPage extends StatefulWidget {
  const LeadBoardPage({super.key});

  @override
  State<LeadBoardPage> createState() => _LeadBoardPageState();
}

class _LeadBoardPageState extends State<LeadBoardPage> {
  List top10 = [];
  getTop10() async {
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: "token");
    var url = Uri.parse("https://quizu.okoul.com/TopScores");

    var response = await http.get(url, headers: {"Authorization": token!});
    var body = jsonDecode(response.body);
    print(body);
    setState(() {
      top10 = body;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTop10();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 25),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                "LeadBoard",
                style: TextStyle(fontSize: 30),
              ),
            ),
            Container(
              height: 420,
              width: MediaQuery.of(context).size.width - 40,
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), //color of shadow
                      spreadRadius: 5, //spread radius
                      blurRadius: 7, // blur radius
                      offset: const Offset(0, 2), // changes position of shadow
                    ),
                    //you can set more BoxShadow() here
                  ],
                  borderRadius: BorderRadius.circular(10)),
              child: ListView.builder(
                itemCount: top10.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              Text(
                                "${top10[index]['name']}",
                                style: TextStyle(fontSize: 17),
                              )
                            ],
                          ),
                          Row(
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              Text(
                                "${top10[index]['score']}",
                                style: TextStyle(fontSize: 17),
                              )
                            ],
                          )
                        ],
                      ),
                      Divider(
                        thickness: 2,
                      )
                    ],
                  );
                  // ignore: prefer_const_constructors
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
