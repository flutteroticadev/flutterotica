import 'package:lit_reader/models/tag.dart';

class TagSearchResults {
  final Meta meta;
  final List<Tag> tags;

  TagSearchResults({
    required this.meta,
    required this.tags,
  });

  factory TagSearchResults.fromJson(Map<String, dynamic> json) {
    return TagSearchResults(
      meta: Meta.fromJson(json['meta']),
      tags: List<Tag>.from(json['tags'].map((x) => Tag.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'meta': meta.toJson(),
      'data': List<dynamic>.from(tags.map((x) => x.toJson())),
    };
  }
}

class Meta {
  final PeriodChecks periodChecks;

  Meta({
    required this.periodChecks,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      periodChecks: PeriodChecks.fromJson(json['period_checks']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'period_checks': periodChecks.toJson(),
    };
  }
}

class PeriodChecks {
  final int? month;
  final int? week;
  final int? today;
  final int? allperiod;

  PeriodChecks({
    this.month,
    this.week,
    this.today,
    this.allperiod,
  });

  factory PeriodChecks.fromJson(Map<String, dynamic> json) {
    return PeriodChecks(
      month: json['month'],
      week: json['week'],
      today: json['today'],
      allperiod: json['allperiod'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'month': month,
      'week': week,
      'today': today,
      'allperiod': allperiod,
    };
  }
}
