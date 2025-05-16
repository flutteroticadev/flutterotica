import 'dart:async';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:flutterotica/env/global.dart';
import 'package:flutterotica/models/list.dart';
import 'package:flutterotica/models/submission.dart';
import 'package:flutterotica/screens/widgets/lit_search_bar.dart';
import 'package:flutterotica/screens/widgets/story_item.dart';

class ListItemListView extends StatefulWidget {
  const ListItemListView({super.key, required this.listName, required this.urlname});

  final String listName;
  final String urlname;

  @override
  State<ListItemListView> createState() => _ListItemListViewState();
}

class _ListItemListViewState extends State<ListItemListView> {
  final ScrollController scrollController = ScrollController();
  final PagingController<int, Submission> _pagingController = PagingController(firstPageKey: 1);
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  int? listId;
  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

//TODO fix infinite scroll page counter
  Future<void> _fetchPage(int pageKey) async {
    try {
      if (widget.urlname.isEmpty) {
        _pagingController.appendLastPage([]);
        return;
      }
      final ListItem newItems = await api.getListItems(widget.urlname, page: pageKey, searchTerm: _searchController.text);
      setState(() {
        listId = newItems.list?.id;
      });

      final isLastPage = pageKey == newItems.works!.meta.lastPage;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems.works!.data);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems.works!.data, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  Future<void> _refresh() async {
    _pagingController.refresh();
  }

  onChangeCustom() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _pagingController.refresh();
    });
  }

  onRemoveFavorite(Submission submission) async {
    await api.toggleListItem(submission.id, listId!, false);

    List<Submission>? olditems = _pagingController.itemList;
    olditems?.removeWhere((element) => element.id == submission.id);
    _pagingController.itemList = [];
    if (olditems != null) {
      _pagingController.appendLastPage(olditems);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          padding: EdgeInsets.zero,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _pagingController.refresh();
            },
          ),
        ],
        title: Text(widget.listName),
      ),
      body: body(formKey),
    );
  }

  Column body(GlobalKey<FormState> formKey) {
    return Column(
      children: <Widget>[
        SafeArea(
          top: true,
          bottom: false,
          child: LitSearchBar(
            formKey: formKey,
            searchFieldTextController: _searchController,
            onChanged: onChangeCustom,
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _refresh,
            child: PagedListView<int, Submission>(
              padding: const EdgeInsets.only(top: 10),
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<Submission>(
                itemBuilder: (context, item, index) => StoryItem(
                  submission: item,
                  onDelete: listId != null ? onRemoveFavorite : null,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
