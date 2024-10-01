// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_speed_dial/flutter_speed_dial.dart';
// import 'package:lit_reader/classes/db_helper.dart';
// import 'package:lit_reader/env/colors.dart';
// import 'package:lit_reader/env/global.dart';
// import 'package:lit_reader/models/page.dart';
// import 'package:lit_reader/models/read_history.dart';
// import 'package:lit_reader/models/story.dart';
// import 'package:lit_reader/models/story_download.dart';
// import 'package:lit_reader/models/submission.dart';
// import 'package:lit_reader/screens/story_details.dart';
// import 'package:lit_reader/screens/widgets/bookmarks_popup_menu.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:text_reader/reader_main.dart';
// import 'package:text_reader/state/controller_state.dart';

// class StoryScreen extends StatefulWidget {
//   const StoryScreen({super.key, required this.submission});

//   final Submission submission;

//   @override
//   State<StoryScreen> createState() => _StoryScreenState();
// }

// class _StoryScreenState extends State<StoryScreen> {
//   late ControllerState controllerState;
//   late Submission submission;

//   // late PageController controller;
//   // ScrollController scrollController = ScrollController();
//   late List<int> existingLists;

//   final List<StoryPage> pages = [];
//   int initialPage = 0;
//   int nextChapter = 0;
//   bool hasNextChapter = false;
//   bool isBusy = false;
//   bool isFabVisible = true;

//   Future<void>? _fetchPagesFuture;

//   bool isDownloaded = false;

//   void updateExistingLists(List<int> newLists) {
//     setState(() {
//       existingLists = newLists;
//     });
//   }

//   setInitState({Submission? setSubmission}) async {
//     initialPage = 0;
//     nextChapter = 0;
//     existingLists = [];
//     hasNextChapter = false;
//     pages.clear();
//     submission = setSubmission ?? widget.submission;
//     // await fetchListData(pSubmission: submission);
//     _fetchPagesFuture = fetchPages(psubmission: submission).then((value) {
//       setState(() {
//         isBusy = false;
//       });
//       List<String> content = pages.map((page) => page.content).toList();
//       // List<dynamic> lastPosition = await _FetchLastPositions();

//       _FetchLastPositions().then((value) {
//         controllerState = ControllerState(contents: content, currentPageIndex: value[0], initialScrollPosition: value[1]);
//       });
//       // controllerState =
//       //     ControllerState(contents: content, currentPageIndex: lastPosition[0], initialScrollPosition: lastPosition[1]);
//     });
//     // WidgetsBinding.instance.addPostFrameCallback((_) {
//     //   _JumpToLastPage();
//     // });
//   }

//   Future<void> fetchPages({Submission? psubmission}) async {
//     psubmission ??= submission;
//     // controller.addListener(_saveCurrentPage);
//     // scrollController.addListener(_saveScrollPosition);

//     DBHelper dbHelper = DBHelper();
//     await dbHelper.init();
//     List<StoryDownload> downloads = await dbHelper.getDownloads(psubmission.url);
//     ReadHistory history = ReadHistory(
//       url: psubmission.url,
//       submission: psubmission,
//     );
//     await dbHelper.addHistory(psubmission.url, history);
//     if (downloads.isNotEmpty) {
//       StoryDownload download = downloads.first;
//       // submission = widget.submission;
//       setState(() {
//         pages.addAll(download.pages);
//         isDownloaded = true;
//       });
//       return;
//     }
//     List<Future<Story>> futures = [];

//     Story firstPageStory = await api.getStory(psubmission.url, page: 1);
//     hasNextChapter = firstPageStory.submission.series.meta.order.isNotEmpty &&
//         firstPageStory.submission.series.meta.order.lastOrNull != psubmission.id;
//     int index = firstPageStory.submission.series.meta.order.indexWhere((c) => c == psubmission!.id);
//     if (hasNextChapter) {
//       nextChapter = firstPageStory.submission.series.meta.order[index + 1];
//     }
//     futures.add(Future.value(firstPageStory));

//     for (int i = 2; i <= firstPageStory.meta.pagesCount; i++) {
//       futures.add(api.getStory(psubmission.url, page: i));
//     }

//     List<Story> stories = await Future.wait(futures);
//     for (int i = 0; i < stories.length; i++) {
//       final page = StoryPage(page: i + 1, content: stories[i].pageText);
//       setState(() {
//         pages.add(page);
//       });
//     }
//   }

//   void _saveCurrentPage(int page) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setInt('${submission.url}_currentpage', page);
//     // ignore: avoid_print
//     print("current page: $page");
//   }

//   void _saveScrollPosition(double position) async {
//     final prefs = await SharedPreferences.getInstance();
//     prefs.setDouble('${submission.url}_scrollPosition', position);
//   }

//   Future<int> _getLastPage() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     int lastPage = prefs.getInt('${submission.url}_currentpage') ?? 0;
//     return lastPage;
//   }

//   Future<double> _getLastPagePosition() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     double scrollPosition = prefs.getDouble('${submission.url}_scrollPosition') ?? 0.0;
//     return scrollPosition;
//   }

//   Future<List<dynamic>> _FetchLastPositions() async {
//     int lastPage = await _getLastPage();
//     double lastPosition = await _getLastPagePosition();

//     return [lastPage, lastPosition];
//   }

//   // ignore: non_constant_identifier_names
//   // _JumpToLastPage() {
//   //   _getLastPage().then((page) {
//   //     WidgetsBinding.instance.addPostFrameCallback((_) {
//   //       // controller.jumpToPage(page);
//   //       controllerState.pageController.jumpToPage(page);
//   //       print("jumping to page: $page");
//   //       _getLastPagePosition().then((scrollPosition) {
//   //         WidgetsBinding.instance.addPostFrameCallback((_) {
//   //           controllerState.pages[page].scrollController.jumpTo(scrollPosition);
//   //           print("jumping to position: $scrollPosition");
//   //           // scrollController.jumpTo(scrollPosition);
//   //         });
//   //       });
//   //     });
//   //   });
//   // }

//   @override
//   void initState() {
//     super.initState();

//     setInitState();
//     SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//       systemNavigationBarColor: Colors.transparent,
//       systemNavigationBarDividerColor: Colors.transparent,
//     ));
//   }

//   @override
//   void dispose() {
//     // controller.removeListener(_saveCurrentPage);
//     // controller.dispose();
//     super.dispose();
//   }

//   downloadStory() async {
//     DBHelper dbHelper = DBHelper();
//     await dbHelper.init();

//     if (isDownloaded) {
//       await dbHelper.removeDownload(submission.url);
//       setState(() {
//         isDownloaded = false;
//       });
//       return;
//     } else {
//       StoryDownload download = StoryDownload(
//         url: submission.url,
//         submission: submission,
//         pages: pages,
//       );
//       await dbHelper.addDownload(submission.url, download);
//       setState(() {
//         isDownloaded = true;
//       });
//     }
//   }

//   double mapValueToRange(double value, double oldMin, double oldMax, {double newMin = 0, double newMax = 100}) {
//     double newValue = (value - oldMin) / (oldMax - oldMin) * (newMax - newMin) + newMin;
//     print('old min: $oldMin, old max: $oldMax');
//     print('old val: $value, new val: $newValue');
//     return newValue;
//   }

//   @override
//   Widget build(BuildContext context) {
//     // print(scrollController.offset);
//     if (isFabVisible) {
//       SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
//     } else {
//       SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack, overlays: []);
//     }
//     return FutureBuilder(
//       future: _fetchPagesFuture,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState != ConnectionState.done || isBusy) {
//           return const Center(child: CircularProgressIndicator());
//         } else {
//           return GestureDetector(
//             onTap: () {
//               setState(() {
//                 isFabVisible = !isFabVisible;
//               });
//             },
//             child: Scaffold(
//               resizeToAvoidBottomInset: false,
//               backgroundColor: Colors.grey[850],
//               body: SafeArea(
//                 top: false,
//                 bottom: false,
//                 child: Stack(children: [
//                   ReaderView(
//                     controllerState: controllerState,
//                     isFullPage: false,
//                     onPageChanged: (index) async {
//                       _saveCurrentPage(index);
//                     },
//                     onScrollPositionChanged: (position) async {
//                       _saveScrollPosition(position);
//                     },
//                   ),
//                   // slider(),
//                   SizedBox(
//                     height: kToolbarHeight + 20,
//                     child: AnimatedOpacity(
//                       opacity: isFabVisible ? 0.98 : 0.0, // Control the opacity with your condition
//                       duration: const Duration(milliseconds: 10), // Control the duration of the animation
//                       curve: Curves.easeInOut,
//                       child: AppBar(
//                         backgroundColor: Colors.grey[900],
//                         leading: IconButton(
//                           visualDensity: VisualDensity.compact,
//                           icon: const Icon(Icons.arrow_back),
//                           onPressed: () {
//                             Navigator.of(context).pop();
//                           },
//                         ),
//                         title: Text(
//                           submission.title,
//                           style: const TextStyle(
//                             fontSize: 18,
//                           ),
//                         ),
//                         actions: [
//                           IconButton(
//                             visualDensity: VisualDensity.compact,
//                             onPressed: () {
//                               knavigatorKey.currentState!.push(MaterialPageRoute(
//                                   builder: (context) => StoryDetailsScreen(
//                                         submission: submission,
//                                       )));
//                             },
//                             icon: const Icon(Icons.info_outline),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ]),
//               ),
//               floatingActionButton: Padding(
//                 padding: const EdgeInsets.only(bottom: 20),
//                 child: SpeedDial(
//                   backgroundColor: kred,
//                   visible: isFabVisible,
//                   animatedIcon: AnimatedIcons.menu_close,
//                   children: [
//                     SpeedDialChild(
//                       child: const Icon(
//                         Icons.bookmark_border,
//                       ),
//                       label: 'Bookmark',
//                       onTap: () async {
//                         await showDialog(
//                           context: context,
//                           builder: (BuildContext context) {
//                             return BookmarksPopupMenu(
//                                 submission: widget.submission,
//                                 existingLists: existingLists,
//                                 onUpdateLists: updateExistingLists,
//                                 context: context);
//                           },
//                         );
//                         // BookmarksPopupMenu(
//                         //   submission: submission,
//                         //   context: context,
//                         // );
//                       },
//                     ),
//                     // if (lists.isNotEmpty)
//                     SpeedDialChild(
//                       child: Icon(
//                         Icons.file_download_outlined,
//                         color: isDownloaded ? kred : null,
//                       ),
//                       label: isDownloaded ? 'Remove from Downloads' : 'Add to Downloads',
//                       onTap: () {
//                         downloadStory();
//                       },
//                     ),
//                     SpeedDialChild(
//                       child: const Icon(Icons.info_outline),
//                       label: 'Details1',
//                       onTap: () {
//                         knavigatorKey.currentState!.push(MaterialPageRoute(
//                             builder: (context) => StoryDetailsScreen(
//                                   submission: submission,
//                                 )));
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         }
//       },
//     );
//   }
// }
