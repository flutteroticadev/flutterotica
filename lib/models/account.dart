import 'dart:convert';

class Account {
  Account({
    required this.login,
    required this.password,
  });

  final String login;
  final String password;

  Map<String, dynamic> toJsonMap() => {
    'login': login,
    'password': password,
  };

  String toJson() => jsonEncode(toJsonMap());

  factory Account.fromJson(Map<String, dynamic> json) => Account(
    login: json['login'],
    password: json['password'],
  );
}
