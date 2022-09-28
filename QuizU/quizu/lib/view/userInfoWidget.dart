// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizu/controllers/userInfoController.dart';

class UserInfoPage extends StatelessWidget {
  const UserInfoPage({super.key});

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
          ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.logout_rounded),
              label: Text("Logout")),
          GetBuilder<UserInfoController>(
            init: UserInfoController(),
            builder: ((controller) {
              // controller.getUserInfo();
              return Center(
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.95,
                      height: MediaQuery.of(context).size.height * 0.55,
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
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: ListView(children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                "Name: ${controller.name}",
                                style: controller.userStyle,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "mobile: ${controller.mobile}",
                                style: controller.userStyle,
                              )
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              // ignore: prefer_const_literals_to_create_immutables
                              children: [
                                Text(
                                  "Time",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Score",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Divider(thickness: 5),
                          Expanded(
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: controller.prevScore.length,
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
                                              "${controller.prevScore[index]['date']}",
                                              style: controller.userStyle,
                                            ),
                                            Text(
                                              "${controller.prevScore[index]['score']}",
                                              style: controller.userStyle,
                                            ),
                                          ],
                                        ),
                                      ),
                                      // ignore: prefer_const_constructors
                                      Divider(
                                        thickness: 2,
                                      )
                                    ],
                                  );
                                }),
                          ),
                        ]),
                      )));
            }),
          ),
        ],
      ),
    );
  }
}
