import 'package:flutter/widgets.dart';
import 'package:flutterotica/env/global.dart';
import 'package:flutterotica/models/submission.dart';

class PrefsFunctions {
  void saveScrollPosition({required Submission submission, required ScrollController scrollController}) async {
    preferences.setDouble('${submission.url}_scrollPosition', scrollController.offset);
  }

  void saveCurrentPage({required Submission submission, required PageController controller}) async {
    if (controller.page != null) {
      preferences.setInt('${submission.url}_currentPage', controller.page!.round());
    }
  }

  int getLastPage({required Submission submission}) {
    int lastPage = preferences.getInt('${submission.url}_currentPage') ?? 0;
    return lastPage;
  }

  double getLastPagePosition({required Submission submission}) {
    double scrollPosition = preferences.getDouble('${submission.url}_scrollPosition') ?? 0.0;
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

  void saveSearchCategories(List<String> categories) {
    preferences.setStringList('searchCategories', categories);
  }

  List<String> getSearchCategories() {
    List<String>? csvCategories = preferences.getStringList('searchCategories');

    // init to no categories
    if (csvCategories == null) {
      preferences.setStringList('searchCategories', []);
      return [];
    }

    return csvCategories;
  }

  bool getHistoryEnabled() {
    bool? historyEnabled = preferences.getBool("historyEnabled");

    // init to false
    if (historyEnabled == null) {
      preferences.setBool("historyEnabled", false);
      return false;
    }

    return historyEnabled;
  }

  void setHistoryEnabled(bool historyEnabled) {
    preferences.setBool("historyEnabled", historyEnabled);
  }
}
