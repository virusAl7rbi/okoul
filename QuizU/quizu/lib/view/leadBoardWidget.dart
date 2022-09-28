// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizu/controllers/leadBaordController.dart';

class LeadBoardPage extends StatelessWidget {
  const LeadBoardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "LeadBoard",
            style: TextStyle(fontSize: 40),
          ),
          GetBuilder<LeadBoardController>(
            init: LeadBoardController(),
            builder: ((controller) {
              return Center(
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.95,
                      height: MediaQuery.of(context).size.height * 0.59,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey
                                  .withOpacity(0.5), //color of shadow
                              spreadRadius: 5, //spread radius
                              blurRadius: 7, // blur radius
                              offset: const Offset(
                                  0, 2), // changes position of shadow
                            ),
                            //you can set more BoxShadow() here
                          ],
                          borderRadius: BorderRadius.circular(10)),
                      child: ListView(children: [
                        SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Name",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Score",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Divider(
                          thickness: 5,
                        ),
                        Expanded(
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: controller.topUsers.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 25,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "${controller.topUsers[index].name}",
                                            style: controller.userStyle,
                                          ),
                                          Text(
                                            "${controller.topUsers[index].score}",
                                            style: controller.userStyle,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      thickness: 3,
                                    )
                                  ],
                                );
                              }),
                        ),
                      ])));
            }),
          ),
        ],
      ),
    );
  }
}
