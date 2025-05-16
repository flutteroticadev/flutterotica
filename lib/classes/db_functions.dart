import 'package:flutterotica/classes/db_helper.dart';
import 'package:flutterotica/models/page.dart';
import 'package:flutterotica/models/story_download.dart';
import 'package:flutterotica/models/submission.dart';

class DbFunctions {
  Future<bool> downloadStory({required Submission submission, required List<StoryPage> pages, required bool isDownloaded}) async {
    DBHelper dbHelper = DBHelper();
    await dbHelper.init();

    if (isDownloaded) {
      await dbHelper.removeDownload(submission.url);

      return false;
    } else {
      StoryDownload download = StoryDownload(
        url: submission.url,
        submission: submission,
        pages: pages,
      );
      await dbHelper.addDownload(submission.url, download);
      return true;
    }
  }
}
