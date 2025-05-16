class Meta {
  final int id;
  final String title;
  final String url;
  final String createdAt;
  final String updatedAt;
  final List<int> order;

  Meta({
    required this.id,
    required this.title,
    required this.url,
    required this.createdAt,
    required this.updatedAt,
    required this.order,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      id: json['id'],
      title: json['title'],
      url: json['url'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      order: List<int>.from(json['order'].map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'url': url,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'order': order,
    };
  }
}
