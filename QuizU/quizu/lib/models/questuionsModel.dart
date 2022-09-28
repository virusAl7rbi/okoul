// To parse this JSON data, do
//
//     final Questions = QuestionsFromJson(jsonString);

// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

List<Questions> QuestionsFromJson(String str) =>
    List<Questions>.from(json.decode(str).map((x) => Questions.fromJson(x)));

String QuestionsToJson(List<Questions> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Questions {
  Questions({
    required this.question,
    required this.a,
    required this.b,
    required this.c,
    required this.d,
    required this.correct,
  });

  String question;
  String a;
  String b;
  String c;
  String d;
  String correct;

  factory Questions.fromJson(Map<String, dynamic> json) => Questions(
        question: json["Question"],
        a: json["a"],
        b: json["b"],
        c: json["c"],
        d: json["d"],
        correct: json["correct"],
      );

  Map<String, dynamic> toJson() => {
        "Question": question,
        "a": a,
        "b": b,
        "c": c,
        "d": d,
        "correct":correct,
      };
}
