// To parse this JSON data, do
//
//     final newName = newNameFromJson(jsonString);

import 'dart:convert';

NewName newNameFromJson(String str) => NewName.fromJson(json.decode(str));

String newNameToJson(NewName data) => json.encode(data.toJson());

class NewName {
  NewName({
    required this.success,
    required this.message,
    required this.name,
    required this.mobile,
  });

  bool success;
  String message;
  String name;
  String mobile;

  factory NewName.fromJson(Map<String, dynamic> json) => NewName(
        success: json["success"],
        message: json["message"],
        name: json["name"],
        mobile: json["mobile"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "name": name,
        "mobile": mobile,
      };
}
