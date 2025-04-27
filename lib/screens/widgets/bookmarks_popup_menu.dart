import 'package:flutter/material.dart';
import 'package:lit_reader/env/colors.dart';
import 'package:lit_reader/env/consts.dart';
import 'package:lit_reader/env/global.dart';
import 'package:lit_reader/models/favorite_list_item.dart';
import 'package:lit_reader/models/favorite_lists.dart';
import 'package:lit_reader/models/submission.dart';

class BookmarksPopupMenu extends StatefulWidget {
  const BookmarksPopupMenu(
      {super.key, required this.submission, required this.existingLists, required this.onUpdateLists, required this.context});
  final Submission submission;
  final BuildContext context;

  final List<int> existingLists;
  final Function(List<int>) onUpdateLists;

  @override
  State<BookmarksPopupMenu> createState() => _BookmarksPopupMenuState();
}

class _BookmarksPopupMenuState extends State<BookmarksPopupMenu> {
  List<FavoriteListItem> favoriteitems = [];
  List<int> get existingLists => widget.existingLists;

  @override
  void initState() {
    super.initState();
    fetchListData();
  }

  @override
  Widget build(context) {
    // late PageController controller;
    // ScrollController scrollController = ScrollController();

    return AlertDialog(
      title: const Text('Bookmarks'),
      content: Column(children: [...favoriteitems.map((listitem) => favoriteItem(listitem, context))]),
      actions: <Widget>[
        TextButton(
          child: const Text('Close'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Future<void> fetchListData() async {
    if (loginController.loginState == LoginState.loggedOut) {
      return;
    }

    List<Lists> lists = listController.list;

    setState(() {
      favoriteitems = lists.map((list) {
        return FavoriteListItem(
          inList: existingLists.contains(list.id),
          list: list,
        );
      }).toList();
    });
  }

  Widget favoriteItem(FavoriteListItem listitem, BuildContext context) {
    return InkWell(
      onTap: () async {
        api.toggleListItem(widget.submission.id, listitem.list.id, !listitem.inList);
        int index = favoriteitems.indexOf(listitem);

        FavoriteListItem updatedItem = FavoriteListItem(
          inList: !listitem.inList,
          list: listitem.list,
        );

        List<int> updatedLists = List.from(existingLists);
        if (updatedItem.inList) {
          updatedLists.add(updatedItem.list.id);
        } else {
          updatedLists.remove(updatedItem.list.id);
        }

        listController.updateList(widget.submission.id, increment: updatedItem.inList);

        widget.onUpdateLists(updatedLists);

        setState(() {
          favoriteitems[index] = updatedItem;
        });
      },
      borderRadius: BorderRadius.circular(5),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
        child: Row(
          children: [
            listitem.inList
                ? const Icon(
                    Icons.bookmark,
                    color: kRed,
                  )
                : const Icon(Icons.bookmark_border),
            Text(listitem.list.title),
          ],
        ),
      ),
    );
  }
}
