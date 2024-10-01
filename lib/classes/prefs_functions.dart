import 'package:flutter/widgets.dart';
import 'package:lit_reader/env/global.dart';
import 'package:lit_reader/models/submission.dart';

class PrefsFunctions {
  void saveScrollPosition({required Submission submission, required ScrollController scrollController}) async {
    prefs.setDouble('${submission.url}_scrollPosition', scrollController.offset);
  }

  void saveCurrentPage({required Submission submission, required PageController controller}) async {
    if (controller.page != null) {
      prefs.setInt('${submission.url}_currentpage', controller.page!.round());
      // ignore: avoid_print
      print("current page: ${controller.page!.round()}");
    }
  }

  int getLastPage({required Submission submission}) {
    int lastPage = prefs.getInt('${submission.url}_currentpage') ?? 0;
    return lastPage;
  }

  double getLastPagePosition({required Submission submission}) {
    double scrollPosition = prefs.getDouble('${submission.url}_scrollPosition') ?? 0.0;
    return scrollPosition;
  }

  jumpToLastPage(
      {required Submission submission, required PageController controller, required ScrollController scrollController}) {
    int lastPage = getLastPage(submission: submission);
    double lastPagePosition = getLastPagePosition(submission: submission);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.jumpToPage(lastPage);
      scrollController.jumpTo(lastPagePosition);
    });
  }

  // cacheLists({required List<Lists> lists}) {
  //   List<Map<String, dynamic>> listsMap = lists.map((list) => list.toJson()).toList();

  //   String jsonString = jsonEncode(listsMap);

  //   prefs.setString("lists", jsonString);
  // }

  // List<Lists> fetchLists() {
  //   String? lists = prefs.getString("lists");

  //   if (lists != null) {
  //     List<dynamic> jsonList = jsonDecode(lists);

  //     List<Lists> listsMap = jsonList.map((list) => Lists.fromJson(list)).toList();
  //     return listsMap;
  //   }
  //   return [];
  // }

  // refreshLists() async {
  //   List<Lists> lists = await api.getLists();
  //   cacheLists(lists: lists);
  // }

  // clearListCache() {
  //   prefs.remove("lists");
  // }
}
