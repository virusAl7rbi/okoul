// To parse this JSON data, do
//
//     final userInfo = userInfoFromJson(jsonString);

import 'dart:convert';

UserInfo userInfoFromJson(String str) => UserInfo.fromJson(json.decode(str));

String userInfoToJson(UserInfo data) => json.encode(data.toJson());

class UserInfo {
  UserInfo({
    required this.mobile,
    required this.name,
  });

  String mobile;
  dynamic name;

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
        mobile: json["mobile"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "mobile": mobile,
        "name": name,
      };
}
