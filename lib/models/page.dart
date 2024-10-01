class StoryPage {
  final int page;
  final String content;

  StoryPage({
    required this.page,
    required this.content,
  });

  factory StoryPage.fromJson(Map<String, dynamic> json) {
    return StoryPage(
      page: json['page'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'content': content,
    };
  }
}
