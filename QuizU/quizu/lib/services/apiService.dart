// ignore_for_file: unused_element, non_constant_identifier_names
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:quizu/models/loginModel.dart';
import 'package:quizu/models/newNameModel.dart';
import 'package:quizu/models/questuionsModel.dart';
import 'package:quizu/models/tokenValidateModel.dart';
import 'package:quizu/models/topUsersModel.dart';
import 'package:quizu/models/userInfoModel.dart';

class ApiClient {
  FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<TokenValidate> tokenValidation() async {
    String? token = await storage.read(key: "token");

    var url = Uri.parse("https://quizu.okoul.com/Token");
    var res = await http.get(url, headers: {"Authorization": token!});

    return tokenValidateFromJson(res.body);
  }

  Future<Login> login(phoneNumber, otp) async {
    var url = Uri.parse("https://quizu.okoul.com/Login");

    var response =
        await http.post(url, body: {"OTP": otp, "mobile": phoneNumber});
    return loginFromJson(response.body);
  }

  Future<NewName> postName(String name) async {
    String? token = await storage.read(key: "token");

    var url = Uri.parse("https://quizu.okoul.com/Name");
    var res = await http
        .post(url, headers: {"Authorization": token!}, body: {"name": name});
    return newNameFromJson(res.body);
  }

  Future<List<TopUsers>> Top10() async {
    String? token = await storage.read(key: "token");

    var url = Uri.parse("https://quizu.okoul.com/TopScores");
    var res = await http.get(url, headers: {"Authorization": token!});
    return topUsersFromJson(res.body).toList();
  }

  Future<UserInfo> userInfo() async {
    String? token = await storage.read(key: "token");
    var url = Uri.parse("https://quizu.okoul.com/UserInfo");
    var res = await http.get(url, headers: {"Authorization": token!});
    return userInfoFromJson(res.body);
  }

  Future<List<Questions>> getQuestions() async {
    String? token = await storage.read(key: "token");

    var url = Uri.parse("https://quizu.okoul.com/Questions");
    var res = await http.get(url, headers: {"Authorization": token!});

    return QuestionsFromJson(res.body);
  }

  newScore(int score) async {
    String? token = await storage.read(key: "token");

    var url = Uri.parse("https://quizu.okoul.com/Score");
    await http.post(url,
        headers: {"Authorization": token!}, body: {"score": "$score"});
  }
}
