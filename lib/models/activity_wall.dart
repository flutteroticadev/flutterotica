import 'package:lit_reader/models/activity_data.dart';

class ActivityWall {
  final List<ActivityData> data;
  final int new_activity_count;

  ActivityWall({
    required this.data,
    required this.new_activity_count,
  });

  factory ActivityWall.fromJson(Map<String, dynamic> json) {
    return ActivityWall(
      data: List<ActivityData>.from(json['data']
          .where((x) => x['action'] == "published-story" && x['what'] is Map)
          .map((x) => ActivityData.fromJson(x))), //only map new stories added
      new_activity_count: json['new_activity_count'],
    );
  }
}
