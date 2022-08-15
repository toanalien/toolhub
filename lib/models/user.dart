class User {
  final String? id;
  final String password;
  late final String balance;

  User({
    this.id,
    required this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        password: json['password'],
      );
}
