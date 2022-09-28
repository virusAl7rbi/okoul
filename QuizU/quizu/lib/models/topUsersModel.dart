// To parse this JSON data, do
//
//     final topUsers = topUsersFromJson(jsonString);

import 'dart:convert';

List<TopUsers> topUsersFromJson(String str) =>
    List<TopUsers>.from(json.decode(str).map((x) => TopUsers.fromJson(x)));

String topUsersToJson(List<TopUsers> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TopUsers {
  TopUsers({
    required this.name,
    required this.score,
  });

  String name;
  dynamic score;

  factory TopUsers.fromJson(Map<String, dynamic> json) => TopUsers(
        name: json["name"] == null ? null : json["name"],
        score: json["score"] == null ? null : json["score"],
      );

  Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "score": score == null ? null : score,
      };
}
