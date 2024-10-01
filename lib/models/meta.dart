class Meta {
  final int pagesCount;

  Meta({
    required this.pagesCount,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      pagesCount: json['pages_count'],
    );
  }
}
