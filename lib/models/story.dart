import 'package:flutterotica/models/meta.dart';
import 'package:flutterotica/models/submission.dart';

class Story {
  final Meta? meta;
  final Submission? submission;
  final String? pageText;

  Story({
    this.meta,
    this.submission,
    this.pageText,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      meta: Meta.fromJson(json['meta']),
      submission: Submission.fromJson(json['submission']),
      pageText: json['pageText'],
    );
  }

  factory Story.empty() {
    return Story();
  }
}
