import 'package:lit_reader/models/submission.dart';
import 'package:lit_reader/models/links.dart';
import 'package:lit_reader/models/works_meta.dart';

class Works {
  final List<Submission> data;
  final List<Links> links;
  final Meta meta;

  Works({
    required this.data,
    required this.links,
    required this.meta,
  });

  factory Works.fromJson(Map<String, dynamic> json) {
    return Works(
      data: List<Submission>.from(json['data'].map((x) => Submission.fromJson(x))),
      links: List<Links>.from(json['links'].map((x) => Links.fromJson(x))),
      meta: Meta.fromJson(json['meta']),
    );
  }
}
