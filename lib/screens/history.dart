import 'dart:async';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flutterotica/classes/db_helper.dart';
import 'package:flutterotica/env/global.dart';
import 'package:flutterotica/models/read_history.dart';
import 'package:flutterotica/models/submission.dart';
import 'package:flutterotica/screens/widgets/drawer_widget.dart';
import 'package:flutterotica/screens/widgets/empty_list_indicator.dart';
import 'package:flutterotica/screens/widgets/lit_search_bar.dart';
import 'package:flutterotica/screens/widgets/story_item.dart';
import 'package:loggy/loggy.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  TextEditingController searchController = TextEditingController();

  final PagingController<int, ReadHistory> _pagingController = PagingController(firstPageKey: 1);
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

      final List<ReadHistory> newItems = await dbHelper.getHistory();

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

  onDeleteHistory(Submission submission) async {
    DBHelper dbHelper = DBHelper();
    await dbHelper.init();
    await dbHelper.removeHistory(submission.url);
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
            Text("History"),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () async {
              return showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Clear History"),
                    content: const Text("Are you sure you want to clear your history?"),
                    actions: [
                      TextButton(
                        child: const Text("Clear"),
                        onPressed: () async {
                          Navigator.of(context).pop();
                          DBHelper dbHelper = DBHelper();
                          await dbHelper.init();
                          await dbHelper.clearHistory();
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
              historyDownloadController.selectedIndex = 1;
              historyDownloadController.selectedTabName = "Downloads";
              historyDownloadController.selectedTabIcon = const Icon(Ionicons.download);
            },
            icon: const Icon(Ionicons.download),
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
              child: PagedListView<int, ReadHistory>(
                pagingController: _pagingController,
                builderDelegate: PagedChildBuilderDelegate<ReadHistory>(
                  itemBuilder: (context, item, index) => StoryItem(
                    submission: item.submission,
                    onDelete: onDeleteHistory,
                  ),
                  noItemsFoundIndicatorBuilder: (_) => const EmptyListIndicator(
                    text: "No stories in your history..."
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
