import "dart:convert";

class User {
  User({required this.username, required this.email, required this.phone});

  factory User.fromJson(String source) =>
      User.fromMap(jsonDecode(source) as Map<String, dynamic>);

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      username: map["username"] as String? ?? "",
      email: map["email"] as String? ?? "",
      phone: map["phone"] as String? ?? "",
    );
  }
  final String username;
  final String email;
  final String phone;

  User copyWith({String? username, String? email, String? phone}) {
    return User(
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
      "User(username: $username, email: $email, phone: $phone)";

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.username == username &&
        other.email == email &&
        other.phone == phone;
  }

  @override
  int get hashCode => username.hashCode ^ email.hashCode ^ phone.hashCode;
}
