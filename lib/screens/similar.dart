import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:lit_reader/env/global.dart';
import 'package:lit_reader/models/submission.dart';
import 'package:lit_reader/screens/widgets/paged_list_view.dart';
import 'package:lit_reader/screens/widgets/story_item.dart';

class SimilarScreen extends StatefulWidget {
  const SimilarScreen({super.key, required this.story});
  final Submission story;

  @override
  State<SimilarScreen> createState() => _SimilarScreenState();
}

class _SimilarScreenState extends State<SimilarScreen> {
  final PagingController<int, Submission> _pagingController = PagingController(firstPageKey: 1);
  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await api.getSimilarStories(widget.story.url);

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
        title: const Text('Similar'),
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
