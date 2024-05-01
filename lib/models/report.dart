// class ReportList {
//   List<Report>? questions;

//   ReportList({
//     this.questions,
//   });

//   ReportList.fromJson(Map<String, dynamic> json) {
//     if (json['results'] != null) {
//       questions = <Report>[];
//       json['results'].forEach((v) {
//         questions!.add(Report.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     if (questions != null) {
//       data['results'] = questions!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

class Report {
  String? uniqKey;
  String? userName;
  String? question;
  String? choice;
  int? score;
  int? id;

  Report(
      {this.uniqKey,
      this.userName,
      this.question,
      this.choice,
      this.score,
      this.id});

  Report.fromJson(Map<String, dynamic> json) {
    uniqKey = json['uniqKey'];
    userName = json['userName'];
    question = json['question'];
    choice = json['choice'];
    score = json['score'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uniqKey'] = uniqKey;
    data['userName'] = userName;
    data['question'] = question;
    data['choice'] = choice;
    data['score'] = score;
    data['id'] = id;
    return data;
  }
}
