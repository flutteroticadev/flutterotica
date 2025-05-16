import 'package:flutterotica/models/author.dart';
import 'package:flutterotica/models/category_info.dart';
import 'package:flutterotica/models/series.dart';
import 'package:flutterotica/models/series_item.dart';
import 'package:flutterotica/models/series_meta.dart';
import 'package:flutterotica/models/tag.dart';

class Submission {
  final int allowVote;
  final int allowDownload;
  final Author? author;
  final String? authorname;
  final CategoryInfo? categoryInfo;
  final int? category;
  final int? commentCount;
  final int contestWinner;
  final String? dateApprove;
  final String description;
  final int enableComments;
  final int favoriteCount;
  final int id;
  final bool isHot;
  final bool isNew;
  final int? language;
  final int newlanguage;
  final dynamic rank;
  final double rateAll;
  final int readingListsCount;
  final List<Tag> tags;
  final String title;
  final String type;
  final String url;
  final int viewCount;
  final bool writersPick;
  final String? status;
  final List<int> followedAuthors;
  final Series series;
  final int readingTime;
  final int wordsCount;
  final List<dynamic> contests;

  Submission({
    required this.allowVote,
    required this.allowDownload,
    this.author,
    this.authorname,
    this.categoryInfo,
    this.category,
    this.commentCount,
    required this.contestWinner,
    this.dateApprove,
    required this.description,
    required this.enableComments,
    required this.favoriteCount,
    required this.id,
    required this.isHot,
    required this.isNew,
    this.language,
    required this.newlanguage,
    required this.rank,
    required this.rateAll,
    required this.readingListsCount,
    required this.tags,
    required this.title,
    required this.type,
    required this.url,
    required this.viewCount,
    required this.writersPick,
    this.status,
    required this.followedAuthors,
    required this.series,
    required this.readingTime,
    required this.wordsCount,
    required this.contests,
  });

  factory Submission.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic value) {
      if (value is int) {
        return value;
      } else if (value is String && value.isNotEmpty) {
        return int.tryParse(value) ?? 0;
      }
      return 0;
    }

    double? parseDouble(dynamic value) {
      if (value is double) {
        return value;
      } else if (value is String && value.isNotEmpty) {
        return double.tryParse(value);
      }
      return null;
    }

    return Submission(
      allowVote: parseInt(json['allow_vote']),
      allowDownload: parseInt(json['allow_download']),
      author: json['author'] != null ? Author.fromJson(json['author']) : Author.fromJson(json['user']),
      authorname: json['user']?["username"].toString() ?? json['authorname'].toString(),
      categoryInfo: json['category_info'] != null ? CategoryInfo.fromJson(json['category_info']) : null,
      category: (parseInt(json['category_id']) == 0 ? null : parseInt(json['category_id'])) ?? json['category'],
      commentCount: json['comment_count'],
      contestWinner: json['contest_winner'] is String ? (json['contest_winner'] == "yes" ? 1 : 0) : json['contest_winner'],
      dateApprove: json['date_published'] ?? json['date_approve'],
      description: json['description'],
      enableComments: parseInt(json['enable_comments']),
      favoriteCount: json['favorite_count'] ?? 0,
      id: parseInt(json['id']),
      isHot: json['is_hot'] is String ? (json['is_hot'] == "yes") : json['is_hot'],
      isNew: json['is_new'] is String ? (json['is_new'] == "yes") : json['is_new'],
      language: json['language'],
      newlanguage: json['newlanguage'] ?? 0,
      rank: json['rank'],
      rateAll: parseDouble(json['rate']) ?? ((json['rate_all'] ?? 0) as num).toDouble(),
      readingListsCount: json['reading_lists_count'] ?? 0,
      tags: json['tags'] != null ? List<Tag>.from(json['tags'].map((x) => Tag.fromJson(x))) : [],
      title: json['name'] ?? json['title'].toString(),
      type: json['type'],
      url: json['url'].replaceAll('https://www.literotica.com/s/', '').replaceAll('https://www.literotica.com/i/', ''),
      viewCount: parseInt(json['view_count']),
      writersPick: json['writers_pick'] is String ? (json['writers_pick'] == "yes") : json['writers_pick'],
      status: json['status'],
      followedAuthors: json['followedAuthors'] != null ? List<int>.from(json['followedAuthors'].map((x) => x)) : [],
      series: json['series'] != null && (json['series'] is Map)
          ? Series.fromJson(json['series'])
          : Series(meta: Meta(id: 0, title: '', url: '', createdAt: '', updatedAt: '', order: []), items: List<Item>.from([])),
      readingTime: json['reading_time'] ?? 0,
      wordsCount: json['words_count'] ?? 0,
      contests: json['contests'] != null ? List<dynamic>.from(json['contests'].map((x) => x)) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'allow_vote': allowVote,
      'allow_download': allowDownload,
      'author': author?.toJson(),
      'authorname': authorname,
      'category_info': categoryInfo?.toJson(),
      'category': category,
      'comment_count': commentCount,
      'contest_winner': contestWinner,
      'date_approve': dateApprove,
      'description': description,
      'enable_comments': enableComments,
      'favorite_count': favoriteCount,
      'id': id,
      'is_hot': isHot,
      'is_new': isNew,
      'language': language,
      'newlanguage': newlanguage,
      'rank': rank,
      'rate_all': rateAll,
      'reading_lists_count': readingListsCount,
      'tags': List<dynamic>.from(tags.map((x) => x.toJson())),
      'title': title,
      'type': type,
      'url': url,
      'view_count': viewCount,
      'writers_pick': writersPick,
      'status': status,
      'followedAuthors': List<dynamic>.from(followedAuthors.map((x) => x)),
      'series': series.toJson(),
      'reading_time': readingTime,
      'words_count': wordsCount,
      'contests': List<dynamic>.from(contests.map((x) => x)),
    };
  }

  Submission copyWithAuthor({Author? author}) {
    return Submission(
      allowVote: allowVote,
      allowDownload: allowDownload,
      author: author ?? this.author,
      authorname: authorname,
      category: category,
      categoryInfo: categoryInfo,
      commentCount: commentCount,
      contestWinner: contestWinner,
      dateApprove: dateApprove,
      description: description,
      enableComments: enableComments,
      favoriteCount: favoriteCount,
      id: id,
      isHot: isHot,
      isNew: isNew,
      language: language,
      newlanguage: newlanguage,
      rank: rank,
      rateAll: rateAll,
      readingListsCount: readingListsCount,
      tags: tags,
      title: title,
      type: type,
      url: url,
      viewCount: viewCount,
      writersPick: writersPick,
      status: status,
      followedAuthors: followedAuthors,
      series: series,
      readingTime: readingTime,
      wordsCount: wordsCount,
      contests: contests,
    );
  }
}
