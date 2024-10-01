import 'package:lit_reader/models/Meta.dart';
import 'package:lit_reader/models/submission.dart';

class Story {
  final Meta meta;
  final Submission submission;
  final String pageText;

  Story({
    required this.meta,
    required this.submission,
    required this.pageText,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      meta: Meta.fromJson(json['meta']),
      submission: Submission.fromJson(json['submission']),
      pageText: json['pageText'],
    );
  }
}
