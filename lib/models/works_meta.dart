class Meta {
  final int total;
  final int currentPage;
  final int lastPage;
  final int from;
  final int to;
  final int perPage;

  Meta({
    required this.total,
    required this.currentPage,
    required this.lastPage,
    required this.from,
    required this.to,
    required this.perPage,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      total: json['total'],
      currentPage: json['current_page'],
      lastPage: json['last_page'],
      from: json['from'] ?? 0,
      to: json['to'] ?? 0,
      perPage: json['per_page'],
    );
  }
}
