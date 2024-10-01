class Listscontent {
  final Map<String, List<dynamic>> content;

  Listscontent({
    required this.content,
  });

  factory Listscontent.fromJson(Map<String, dynamic> json) {
    final content = Map<String, List<dynamic>>.from(json);
    return Listscontent(content: content);
  }

  Map<String, dynamic> toJson() {
    return content;
  }
}
