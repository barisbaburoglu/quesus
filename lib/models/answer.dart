class Answer {
  int? optionId;
  int? userId;

  Answer({
    this.optionId,
    this.userId,
  });

  Answer.fromJson(Map<String, dynamic> mapOfJson)
      : optionId = mapOfJson["optionId"],
        userId = mapOfJson["userId"];

  Map<String, dynamic> toJson() => {
        'optionId': optionId,
        'userId': userId,
      };
}
