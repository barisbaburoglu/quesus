import 'option.dart';

class QuestionList {
  List<Question>? questions;
  int? questionCount;

  QuestionList({this.questions, this.questionCount});

  QuestionList.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      questions = <Question>[];
      json['results'].forEach((v) {
        questions!.add(Question.fromJson(v));
      });
    }
    questionCount = json['questionCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (questions != null) {
      data['results'] = questions!.map((v) => v.toJson()).toList();
    }
    data['questionCount'] = questionCount;
    return data;
  }
}

class Question {
  int? id;
  String? question;
  int? bankId;
  String? keywords;
  int? isActive;
  List<Option>? options;

  Question({this.id, this.question, this.bankId, this.keywords, this.options});

  Question.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    bankId = json['bankId'];
    keywords = json['keywords'];
    isActive = json['isActive'];
    if (json['options'] != null) {
      options = <Option>[];
      json['options'].forEach((v) {
        options!.add(Option.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) data['id'] = id;
    data['question'] = question;
    data['bankId'] = bankId;
    data['keywords'] = keywords;
    data['isActive'] = isActive;
    if (options != null) {
      data['options'] = options!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
