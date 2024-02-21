class User {
  String? id;
  String? fullName;
  int? age;
  int? gender;
  String? mobile;
  String? username;
  String? email;

  User(
      {this.id,
      this.fullName,
      this.age,
      this.gender,
      this.mobile,
      this.username,
      this.email});

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return User(
        id: parsedJson['id'] ?? "",
        fullName: parsedJson['fullName'] ?? "",
        age: parsedJson['age'] ?? "",
        gender: parsedJson['gender'] ?? 0,
        mobile: parsedJson['mobile'] ?? 0,
        username: parsedJson['username'] ?? 0,
        email: parsedJson['email'] ?? 0);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'age': age,
      'gender': gender,
      'mobile': mobile,
      'username': username,
      'email': email,
    };
  }
}
