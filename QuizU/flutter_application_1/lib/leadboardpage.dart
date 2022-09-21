// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class LeadBoardPage extends StatefulWidget {
  const LeadBoardPage({super.key});

  @override
  State<LeadBoardPage> createState() => _LeadBoardPageState();
}

class _LeadBoardPageState extends State<LeadBoardPage> {
  var topUsers = [];
  @override
  Widget build(BuildContext context) {
    return Column(
      // ignore: prefer_const_literals_to_create_immutables
      children: [
        Center(
            child: Column(
          children: [
            Text("LeadBoard", style: TextStyle(fontSize: 30)),
            GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 20),
                itemBuilder: (BuildContext context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Row(crossAxisAlignment: CrossAxisAlignment.start,
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              Text(
                                "username",
                              )
                            ]),
                        Row(crossAxisAlignment: CrossAxisAlignment.end,
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              Text(
                                "Score",
                              )
                            ]),
                      ],
                    ),
                  );
                })
          ],
        )),
      ],
    );
  }
}
