import 'package:lit_reader/models/series_meta.dart';
import 'package:lit_reader/models/series_item.dart';

class Series {
  final Meta meta;
  final List<Item> items;

  Series({
    required this.meta,
    required this.items,
  });

  factory Series.fromJson(Map<String, dynamic> json) {
    return Series(
      meta: Meta.fromJson(json['meta']),
      items: List<Item>.from(json['items'].map((x) => Item.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'meta': meta.toJson(),
      'items': List<dynamic>.from(items.map((x) => x.toJson())),
    };
  }
}
