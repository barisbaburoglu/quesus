class Answer {
  String uniqKey;
  int? optionId;
  int? userId;

  Answer({
    required this.uniqKey,
    this.optionId,
    this.userId,
  });

  Answer.fromJson(Map<String, dynamic> mapOfJson)
      : uniqKey = mapOfJson["uniqKey"],
        optionId = mapOfJson["optionId"],
        userId = mapOfJson["userId"];

  Map<String, dynamic> toJson() => {
        'uniqKey': uniqKey,
        'optionId': optionId,
        'userId': userId,
      };
}
