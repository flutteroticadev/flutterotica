class Token {
  String? token;
  DateTime? expires;

  Token({
    this.token,
    this.expires,
  });

  Token copyWith({
    String? token,
    DateTime? expires,
  }) {
    return Token(
      token: token ?? this.token,
      expires: expires ?? this.expires,
    );
  }
}
