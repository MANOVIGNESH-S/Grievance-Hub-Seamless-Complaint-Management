class User {
  final String name;
  final String email;
  final String password;
  final String type;
  final String? mobile;

  User({
    required this.name,
    required this.email,
    required this.password,
    required this.type,
    this.mobile,
  });

  String toJson() => '$name,$email,$password,$type,${mobile ?? ""}';

  factory User.fromJson(String json) {
    final parts = json.split(',');
    return User(
      name: parts[0],
      email: parts[1],
      password: parts[2],
      type: parts[3],
      mobile: parts.length > 4 ? parts[4] : null,
    );
  }

  User copyWith({
    String? name,
    String? email,
    String? password,
    String? type,
    String? mobile,
  }) {
    return User(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      type: type ?? this.type,
      mobile: mobile ?? this.mobile,
    );
  }
}
