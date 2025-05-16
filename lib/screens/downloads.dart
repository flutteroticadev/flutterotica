import 'dart:async';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flutterotica/classes/db_helper.dart';
import 'package:flutterotica/env/global.dart';
import 'package:flutterotica/models/story_download.dart';
import 'package:flutterotica/models/submission.dart';
import 'package:flutterotica/screens/widgets/drawer_widget.dart';
import 'package:flutterotica/screens/widgets/empty_list_indicator.dart';
import 'package:flutterotica/screens/widgets/lit_search_bar.dart';
import 'package:flutterotica/screens/widgets/story_item.dart';
import 'package:loggy/loggy.dart';

class DownloadScreen extends StatefulWidget {
  const DownloadScreen({super.key});

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  TextEditingController searchController = TextEditingController();

  final PagingController<int, StoryDownload> _pagingController = PagingController(firstPageKey: 1);
  Timer? _debounce;

  onChangeCustom() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _pagingController.refresh();
    });
  }

  Future<void> _fetchPage() async {
    try {
      DBHelper dbHelper = DBHelper();
      await dbHelper.init();
      _pagingController.itemList = [];

      final List<StoryDownload> newItems = await dbHelper.getDownloads();

      _pagingController.appendLastPage(newItems
          .where((item) =>
              (item.submission.title.toLowerCase().contains(searchController.text.toLowerCase())) ||
              item.submission.description.toLowerCase().contains(searchController.text.toLowerCase()))
          .toList());
    } catch (error) {
      _pagingController.error = error;
    }
  }

  Future<void> _refresh() async {
    _pagingController.refresh();
  }

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage();
    });
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  onDeleteDownload(Submission submission) async {
    DBHelper dbHelper = DBHelper();
    await dbHelper.init();
    await dbHelper.removeDownload(submission.url);
    await _fetchPage();

    logInfo('Deleted: ${submission.title}');
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBar(
        surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        titleSpacing: null,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Downloads"),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () async {
              return showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Clear Downloads"),
                    content: const Text("Are you sure you want to clear your downloads?"),
                    actions: [
                      TextButton(
                        child: const Text("Clear"),
                        onPressed: () async {
                          Navigator.of(context).pop();
                          DBHelper dbHelper = DBHelper();
                          await dbHelper.init();
                          await dbHelper.clearDownloads();
                          _pagingController.refresh();
                        },
                      ),
                      TextButton(
                        child: const Text("Cancel"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.delete),
          ),
          IconButton(
            onPressed: () {
              historyDownloadController.selectedIndex = 0;
              historyDownloadController.selectedTabName = "History";
              historyDownloadController.selectedTabIcon = const Icon(Ionicons.time);
            },
            icon: const Icon(Ionicons.time),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          LitSearchBar(
            formKey: formKey,
            searchFieldTextController: searchController,
            onChanged: onChangeCustom,
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: PagedListView<int, StoryDownload>(
                pagingController: _pagingController,
                builderDelegate: PagedChildBuilderDelegate<StoryDownload>(
                  itemBuilder: (context, item, index) => StoryItem(
                    submission: item.submission,
                    onDelete: onDeleteDownload,
                  ),
                  noItemsFoundIndicatorBuilder: (_) => const EmptyListIndicator(
                    text: "No stories in your downloads...",
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
