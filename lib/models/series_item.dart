import 'package:lit_reader/models/categoryInfo.dart';

class Item {
  final int id;
  final CategoryInfo categoryInfo;
  final int category;
  final String title;
  final String type;
  final String url;

  Item({
    required this.id,
    required this.categoryInfo,
    required this.category,
    required this.title,
    required this.type,
    required this.url,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      categoryInfo: CategoryInfo.fromJson(json['category_info']),
      category: json['category'],
      title: json['title'],
      type: json['type'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_info': categoryInfo.toJson(),
      'category': category,
      'title': title,
      'type': type,
      'url': url,
    };
  }
}
