import 'package:lit_reader/models/search_meta.dart';
import 'package:lit_reader/models/submission.dart';

class SearchResult {
  final Meta? meta;
  final List<Submission> data;

  SearchResult({
    this.meta,
    required this.data,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      meta: Meta.fromJson(json['meta']),
      data: List<Submission>.from(json['data'].map((x) => Submission.fromJson(x))),
    );
  }

  factory SearchResult.empty() {
    return SearchResult(
      meta: null,
      data: [],
    );
  }
}
