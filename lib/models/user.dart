class User {
  int? id;
  String? userName;
  String? password;
  int? isAdmin;
  int? isActive;
  String? error = "";

  User(
      {this.id,
      this.userName,
      this.password,
      this.isAdmin,
      this.isActive,
      this.error});

  User.fromJson(Map<String, dynamic> mapOfJson)
      : id = mapOfJson["id"] ?? 0,
        userName = mapOfJson["userName"] ?? "",
        password = mapOfJson["password"] ?? "",
        isAdmin = mapOfJson["isAdmin"] ?? 0,
        isActive = mapOfJson["isActive"] ?? 0;

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        if (userName != null) 'userName': userName,
        if (password != null) 'password': password,
        if (isAdmin != null) 'isAdmin': isAdmin,
        if (isActive != null) 'isActive': isActive,
      };

  Map<String, dynamic> toJsonLogin() => {
        'userName': userName,
        'password': password,
      };
}