// To parse this JSON data, do
//
//     final tokenValidate = tokenValidateFromJson(jsonString);

import 'dart:convert';

TokenValidate tokenValidateFromJson(String str) =>
    TokenValidate.fromJson(json.decode(str));

String tokenValidateToJson(TokenValidate data) => json.encode(data.toJson());

class TokenValidate {
  TokenValidate({
    required this.success,
    required this.message,
  });

  bool success;
  String message;

  factory TokenValidate.fromJson(Map<String, dynamic> json) => TokenValidate(
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
      };
}
