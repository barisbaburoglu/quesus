import 'dart:convert';
import 'dart:developer';

// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/secret.dart';
import '../models/answer.dart';
import '../models/bank.dart';
import '../models/question.dart';
import '../models/user.dart';

class ApiQueSus {
  Future<User> login(User user) async {
    final response = await http.post(
      Uri.parse('$api/questions/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'username': user.userName,
        'password': user.password,
      }),
    );

    if (response.statusCode == 200) {
      User user = User.fromJson(jsonDecode(response.body));
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt("userId", user.id!);
      prefs.setString("userName", user.userName!);
      prefs.setInt("isAdmin", user.isAdmin!);

      return user;
    } else {
      // Hata durumunda hata mesajını kullanıcıya göstermek için yeni bir User nesnesi oluştur
      return User(
          error: "Giriş Başarısız!\n\nLütfen bilgilerinizi kontrol ediniz!");
    }
  }

  Future<Answer> createAnswer(Answer answer) async {
    final response = await http.post(
      Uri.parse('$api/questions/createanswer'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(answer.toJson()),
    );

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return Answer.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create answer.');
    }
  }

  Future<User> createUser(User user) async {
    final response = await http.post(
      Uri.parse('$api/questions/createuser'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create user.');
    }
  }

  Future<List<User>> getUsers(String? userName) async {
    final response = await http.get(
      Uri.parse('$api/questions/GetUsers?userName=$userName'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      var statesJsonArray = json.decode(response.body);
      List<User> results =
          (statesJsonArray as List).map((e) => User.fromJson(e)).toList();
      return results;
    } else {
      throw Exception('Failed to get Users.');
    }
  }

  Future<bool> updateUser(User user) async {
    var json = jsonEncode(user.toJson());
    final response = await http.put(
      Uri.parse('$api/questions/updateuser'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteUser(User user) async {
    var json = jsonEncode(user.toJson());
    final response = await http.delete(
      Uri.parse('$api/questions/deleteuser'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<Question> createQuestion(Question question) async {
    var json = jsonEncode(question.toJson());
    final response = await http.post(
      Uri.parse('$api/questions/createquestion'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json,
    );

    if (response.statusCode == 200) {
      return Question.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create Question.');
    }
  }

  Future<bool> updateQuestion(Question question) async {
    var json = jsonEncode(question.toJson());
    final response = await http.put(
      Uri.parse('$api/questions/updatequestion'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteQuestion(Question question) async {
    var json = jsonEncode(question.toJson());
    final response = await http.delete(
      Uri.parse('$api/questions/deletequestion'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<QuestionList> getQuestions(
      int bankId, int isAll, String searchQuestion) async {
    final response = await http.post(
      Uri.parse('$api/questions/GetQuestions'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'bankId': bankId,
        'isAll': isAll,
        'question': searchQuestion,
      }),
    );

    if (response.statusCode == 200) {
      try {
        log('api worked ${response.body}');
        var body = response.body;
        var statesJsonArray = json.decode(body.toString());

        QuestionList results = QuestionList.fromJson(statesJsonArray);

        return results;
      } catch (e) {
        log('try failed $e');

        return QuestionList();
      }
    } else {
      log('api request failed ${response.body}');

      return QuestionList();
    }
  }

  Future<bool> updateBank(Bank bank) async {
    var json = jsonEncode(bank.toJson());
    final response = await http.put(
      Uri.parse('$api/questions/updatebank'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
