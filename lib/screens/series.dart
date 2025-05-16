import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:flutterotica/env/global.dart';
import 'package:flutterotica/models/submission.dart';
import 'package:flutterotica/screens/widgets/paged_list_view.dart';
import 'package:flutterotica/screens/widgets/story_item.dart';

class SeriesScreen extends StatefulWidget {
  const SeriesScreen({super.key, required this.story});
  final Submission story;

  @override
  State<SeriesScreen> createState() => _SeriesScreenState();
}

class _SeriesScreenState extends State<SeriesScreen> {
  final PagingController<int, Submission> _pagingController = PagingController(firstPageKey: 1);
  Future<void> _fetchPage(int pageKey) async {
    try {
      final story = await api.getStory(widget.story.url);
      final newItems =
          story.submission?.series.meta.id != null ? await api.getSeries(story.submission!.series.meta.id) : <Submission>[];

      _pagingController.appendLastPage(newItems);
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Series'),
      ),
      body: Padding(
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
      ),
    );
  }
}
