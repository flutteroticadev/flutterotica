import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:flutterotica/classes/search_config.dart';
import 'package:flutterotica/data/categories.dart';
import 'package:flutterotica/env/colors.dart';
import 'package:flutterotica/env/consts.dart';
import 'package:flutterotica/env/global.dart';
import 'package:flutterotica/models/tag.dart';
import 'package:flutterotica/screens/widgets/drawer_widget.dart';
import 'package:flutterotica/screens/widgets/lit_badge.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final PagingController<int, Tag> _tagPagingController = PagingController(firstPageKey: 1);
  final PagingController<int, Category> _categoryPagingController = PagingController(firstPageKey: 1);

  List<Category> categoryItems = [];

  @override
  void initState() {
    litSearchController.categoriesRx.listen((categories) {
      if (categories.isNotEmpty) {
        _refreshAndAppendCategories(categories);
      }
    });

    _categoryPagingController.appendLastPage(categoryItems);

    _categoryPagingController.addPageRequestListener((pageKey) {
      litSearchController.getCategories();
    });

    _tagPagingController.addPageRequestListener((pageKey) {
      _fetchPage();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        title: const Text('Explore'),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            popularCategories(),
            popularTags(),
          ],
        ),
      ),
    );
  }

  Future<void> _fetchPage() async {
    try {
      _tagPagingController.itemList = [];

      final List<Tag> newItems = await api.getPopularTags();

      _tagPagingController.appendLastPage(newItems.toList());
    } catch (error) {
      _tagPagingController.error = error;
    }
  }

  void _refreshAndAppendCategories(List<Category> categories) {
    _categoryPagingController.refresh();
    final categoryItems = categories.where((cat) => cat.type == "story" && cat.id != 1).toList();
    _categoryPagingController.appendLastPage(categoryItems);
  }

  Widget popularTags() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(bottom: 8, left: 8, right: 8, top: 4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).secondaryHeaderColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(
                left: 16,
                bottom: 16,
              ),
              child: Text(
                'Popular Tags',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => Future.sync(() => _tagPagingController.refresh()),
                child: PagedListView<int, Tag>(
                  pagingController: _tagPagingController,
                  builderDelegate: PagedChildBuilderDelegate<Tag>(
                    itemBuilder: (context, item, index) => Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text(item.tag),
                        trailing: Text(
                          item.count.toString(),
                          style: const TextStyle(
                            color: kRed,
                            fontSize: 14,
                          ),
                        ),
                        onTap: () {
                          SearchConfig searchConfig = SearchConfig.tagSearch(
                            tagList: [item.tag],
                            sortOrder: SearchSortField.voteDesc,
                            sortString: SearchString.voteDesc,
                          );
                          navigateToSearch(searchConfig);
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget popularCategories() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(bottom: 4, left: 8, right: 8, top: 8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).secondaryHeaderColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(
                left: 16,
                bottom: 16,
              ),
              child: Text(
                'Categories',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => Future.sync(() => _categoryPagingController.refresh()),
                child: PagedListView<int, Category>(
                  pagingController: _categoryPagingController,
                  builderDelegate: PagedChildBuilderDelegate<Category>(
                    itemBuilder: (context, item, index) => Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        isThreeLine: true,
                        tileColor: Theme.of(context).scaffoldBackgroundColor,
                        title: Text(item.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.ldesc),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  child: const LitBadge(text: 'Top', color: kHotTag),
                                  onTap: () {
                                    SearchConfig searchConfig = SearchConfig.categorySearch(
                                      selectedCategory: item.id,
                                    );
                                    navigateToSearch(searchConfig);
                                    litSearchController.selectedCategory = [item.id.toString()];
                                  },
                                ),
                                InkWell(
                                  child: const LitBadge(text: 'New', color: kNewTag),
                                  onTap: () {
                                    SearchConfig searchConfig = SearchConfig.categorySearch(
                                      selectedCategory: item.id,
                                      newOnly: true,
                                    );
                                    navigateToSearch(searchConfig);
                                    litSearchController.selectedCategory = [item.id.toString()];
                                  },
                                ),
                                InkWell(
                                  child: const LitBadge(text: 'Random', color: kWinnerTag),
                                  onTap: () {
                                    SearchConfig searchConfig = SearchConfig.categorySearch(
                                      selectedCategory: item.id,
                                      random: true,
                                    );
                                    navigateToSearch(searchConfig);
                                    litSearchController.selectedCategory = [item.id.toString()];
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
