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
}
