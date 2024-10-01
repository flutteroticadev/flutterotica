import 'dart:convert';

class Account {
  Account({
    required this.login,
    required this.password,
  });
  // }) : timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;

  final String login;
  final String password;
  // final int timestamp;

  Map<String, dynamic> toJsonMap() => {
        'login': login,
        'password': password,
        // 'timestamp': timestamp,
      };

  String toJson() => jsonEncode(toJsonMap());

  factory Account.fromJson(Map<String, dynamic> json) => Account(
        login: json['login'],
        password: json['password'],
      );
}
