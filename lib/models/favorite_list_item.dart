import 'package:lit_reader/models/favorite_lists.dart';

class FavoriteListItem {
  final bool inList;
  final Lists list;

  FavoriteListItem({
    required this.inList,
    required this.list,
  });
}
