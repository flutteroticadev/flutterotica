class Meta {
  final int pageSize;
  final int total;

  Meta({
    required this.pageSize,
    required this.total,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      pageSize: json['pageSize'],
      total: json['total'],
    );
  }
}
