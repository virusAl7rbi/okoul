// To parse this JSON data, do
//
//     final login = loginFromJson(jsonString);

import 'dart:convert';

Login loginFromJson(String str) => Login.fromJson(json.decode(str));

String loginToJson(Login data) => json.encode(data.toJson());

class Login {
  Login({
    required this.success,
    required this.message,
    required this.token,
    this.name,
    required this.mobile,
  });

  bool success;
  String message;
  String token;
  String? name;
  String mobile;

  factory Login.fromJson(Map<String, dynamic> json) => Login(
        success: json["success"],
        message: json["message"],
        token: json["token"],
        name: json["name"],
        mobile: json["mobile"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "token": token,
        "name": name,
        "mobile": mobile,
      };
}
