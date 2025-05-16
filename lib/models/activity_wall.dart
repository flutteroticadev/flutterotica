import 'package:flutterotica/models/activity_data.dart';

class ActivityWall {
  final List<ActivityData> data;
  final int newActivityCount;

  ActivityWall({
    required this.data,
    required this.newActivityCount,
  });

  factory ActivityWall.fromJson(Map<String, dynamic> json) {
    return ActivityWall(
      data: List<ActivityData>.from(json['data']
          .where((x) => x['action'] == "published-story" && x['what'] is Map)
          .map((x) => ActivityData.fromJson(x))), //only map new stories added
      newActivityCount: json['new_activity_count'],
    );
  }
}
