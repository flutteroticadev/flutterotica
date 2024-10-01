class Meta {
  final int id;
  final String title;
  final String url;
  final String created_at;
  final String updated_at;
  final List<int> order;

  Meta({
    required this.id,
    required this.title,
    required this.url,
    required this.created_at,
    required this.updated_at,
    required this.order,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      id: json['id'],
      title: json['title'],
      url: json['url'],
      created_at: json['created_at'],
      updated_at: json['updated_at'],
      order: List<int>.from(json['order'].map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'url': url,
      'created_at': created_at,
      'updated_at': updated_at,
      'order': order,
    };
  }
}
