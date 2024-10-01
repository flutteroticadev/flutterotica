import 'package:lit_reader/models/favorite_lists.dart';
import 'package:lit_reader/models/list_works.dart';

class ListItem {
  final Lists? list;
  final Works? works;
  ListItem({
    required this.list,
    required this.works,
  });

  factory ListItem.fromJson(Map<String, dynamic> json) {
    return ListItem(
      list: Lists.fromJson(json['list']),
      works: Works.fromJson(json['works']),
    );
  }
}
