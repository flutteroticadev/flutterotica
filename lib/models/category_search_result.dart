import 'package:lit_reader/models/submission.dart';

class CategorySearchResult {
  final CategoryMeta meta;
  final List<Submission> data;
  final int total;

  CategorySearchResult({
    required this.meta,
    required this.data,
    required this.total,
  });

  factory CategorySearchResult.fromJson(Map<String, dynamic> json) {
    return CategorySearchResult(
      meta: CategoryMeta.fromJson(json['meta']),
      data: List<Submission>.from(json['submissions'].map((x) => Submission.fromJson(x))),
      total: int.tryParse(json['total'].toString()) ?? 0,
    );
  }
}

class CategoryMeta {
  final int pages;
  final int page;
  final int limit;

  CategoryMeta({
    required this.pages,
    required this.page,
    required this.limit,
  });

  factory CategoryMeta.fromJson(Map<String, dynamic> json) {
    return CategoryMeta(
      pages: json['pages'],
      page: json['page'],
      limit: json['limit'],
    );
  }
}
