import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:flutterotica/env/consts.dart';
import 'package:flutterotica/env/global.dart';
import 'package:flutterotica/models/activity_data.dart';
import 'package:flutterotica/screens/widgets/drawer_widget.dart';
import 'package:flutterotica/screens/widgets/empty_list_indicator.dart';
import 'package:flutterotica/screens/widgets/logged_in_error.dart';
import 'package:flutterotica/screens/widgets/paged_list_view.dart';
import 'package:flutterotica/screens/widgets/story_item.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late final PagingController<int, ActivityData> _pagingController;

  int? lastId;
  Future<void> _fetchPage(int pageKey) async {
    try {
      if (pageKey == 1) {
        lastId = null;
      }
      int limit = 25;
      final newItems = await api.getFeed(limit: limit, lastId: lastId);

      lastId = newItems.data.last.id;

      //check if last page

      final nextPageItems = await api.getFeed(limit: limit, lastId: lastId);
      if (nextPageItems.data.isEmpty) {
        _pagingController.appendLastPage(newItems.data);
        return;
      }
      final nextPageKey = pageKey + 1;
      _pagingController.appendPage(newItems.data, nextPageKey);
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void initState() {
    _pagingController = PagingController(firstPageKey: 1);
    _pagingController.addPageRequestListener((pageKey) {
      if (loginController.loginState == LoginState.loggedIn) {
        _fetchPage(pageKey);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBar(
        surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text('Feed'),
      ),
      body: body(),
    );
  }

  Widget body() {
    return Obx(() {
      if (loginController.loginState == LoginState.loggedIn) {
        return Column(
          children: [
            Expanded(
              child: LitPagedListView<ActivityData>(
                pagingController: _pagingController,
                fetchPage: _fetchPage,
                itemBuilder: (context, item, index) {
                  return StoryItem(
                    submission: item.what,
                  );
                },
                emptyListBuilder: (_) => const EmptyListIndicator(
                  text: "No stories in your feed",
                ),
              ),
            ),
          ],
        );
      } else if (loginController.loginState == LoginState.loggedOut || loginController.loginState == LoginState.failure) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 1),
          child: LoggedInError(
            text: "You must be logged in to view your feed",
          ),
        );
      } else {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    });
  }
}
