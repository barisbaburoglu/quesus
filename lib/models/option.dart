class Option {
  int? id;
  String? choice;
  int? score;

  Option({
    this.id,
    this.choice,
    this.score,
  });

  Option.fromJson(Map<String, dynamic> mapOfJson)
      : id = mapOfJson["id"],
        choice = mapOfJson["choice"],
        score = mapOfJson["score"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) {
      data['id'] = id;
    }
    data['choice'] = choice;
    data['score'] = score;

    return data;
  }
}
