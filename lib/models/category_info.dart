class CategoryInfo {
  final String type;
  final String pageUrl;

  CategoryInfo({
    required this.type,
    required this.pageUrl,
  });

  factory CategoryInfo.fromJson(Map<String, dynamic> json) {
    return CategoryInfo(
      type: json['type'],
      pageUrl: json['pageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'pageUrl': pageUrl,
    };
  }
}
