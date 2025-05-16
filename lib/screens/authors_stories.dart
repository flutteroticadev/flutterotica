import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:flutterotica/env/global.dart';
import 'package:flutterotica/models/author.dart';
import 'package:flutterotica/models/submission.dart';
import 'package:flutterotica/screens/widgets/paged_list_view.dart';
import 'package:flutterotica/screens/widgets/story_item.dart';

class AuthorsStoriesScreen extends StatefulWidget {
  const AuthorsStoriesScreen({super.key, required this.author, this.listOnly = false});
  final Author author;
  final bool listOnly;

  @override
  State<AuthorsStoriesScreen> createState() => _AuthorsStoriesScreenState();
}

class _AuthorsStoriesScreenState extends State<AuthorsStoriesScreen> {
  final PagingController<int, Submission> _pagingController = PagingController(firstPageKey: 1);
  int maxPages = 1;
  Future<void> _fetchPage(int pageKey) async {
    try {
      // final story = await api.getStory(widget.story.url);
      if (pageKey == 1) {
        final result = await api.getAuthorStories(widget.author.username);
        final newItems = result.data;
        if (result.meta != null) {
          maxPages = (result.meta!.total / (result.meta!.pageSize)).ceil();
        }

        if (pageKey == maxPages) {
          _pagingController.appendLastPage(newItems);
        } else {
          _pagingController.appendPage(newItems, pageKey + 1);
        }
      } else {
        if (pageKey <= maxPages) {
          final result = await api.getAuthorStories(widget.author.username, page: pageKey);
          final newItems = result.data;

          if (pageKey == maxPages) {
            _pagingController.appendLastPage(newItems);
          } else {
            _pagingController.appendPage(newItems, pageKey + 1);
          }
        }
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.listOnly) {
      return body();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Author\'s Stories'),
      ),
      body: body(),
    );
  }

  Widget body() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Column(
        children: <Widget>[
          Expanded(
            child: LitPagedListView<Submission>(
              pagingController: _pagingController,
              fetchPage: _fetchPage,
              itemBuilder: (context, item, index) {
                return Center(
                    child: StoryItem(
                  submission: item,
                ));
              },
            ),
          ),
        ],
      ),
    );
  }
}
