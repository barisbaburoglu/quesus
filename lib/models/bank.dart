class Bank {
  int? id;
  String? header;
  String? description;
  int? questionCount;

  Bank({
    this.id,
    this.header,
    this.description,
    this.questionCount,
  });

  Bank.fromJson(Map<String, dynamic> mapOfJson)
      : id = mapOfJson["id"],
        header = mapOfJson["header"],
        description = mapOfJson["description"],
        questionCount = mapOfJson["questionCount"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) {
      data['id'] = id;
    }
    data['header'] = header;
    data['description'] = description;
    data['questionCount'] = questionCount;

    return data;
  }
}
