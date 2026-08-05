import "dart:convert";

import "package:movify/domain/entities/user.dart";

class UserModel {
  UserModel({required this.username, required this.email, required this.phone});

  factory UserModel.fromEntity(User user) =>
      UserModel(username: user.username, email: user.email, phone: user.phone);

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(jsonDecode(source) as Map<String, dynamic>);

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      username: map["username"] as String? ?? "",
      email: map["email"] as String? ?? "",
      phone: map["phone"] as String? ?? "",
    );
  }
  final String username;
  final String email;
  final String phone;

  User toEntity() => User(username: username, email: email, phone: phone);

  UserModel copyWith({String? username, String? email, String? phone}) {
    return UserModel(
      username: username ?? this.username,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }

  Map<String, dynamic> toMap() {
    return {"username": username, "email": email, "phone": phone};
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      "UserModel(username: $username, email: $email, phone: $phone)";

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.username == username &&
        other.email == email &&
        other.phone == phone;
  }

  @override
  int get hashCode => username.hashCode ^ email.hashCode ^ phone.hashCode;
}
