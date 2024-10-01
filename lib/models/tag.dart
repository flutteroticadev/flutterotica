class Tag {
  final int id;
  final String tag;
  final int isBanned;
  final int? language;
  final int? count;

  Tag({
    required this.id,
    required this.tag,
    required this.isBanned,
    this.language,
    this.count,
  });

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json['id'],
      tag: json['tag'].toString(),
      isBanned: json['is_banned'],
      language: json['language'] ?? 1,
      count: json['cnt'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tag': tag,
      'is_banned': isBanned,
      'language': language,
      'cnt': count,
    };
  }
}
