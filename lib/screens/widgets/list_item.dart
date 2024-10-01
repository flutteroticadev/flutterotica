import 'package:flutter/material.dart';
import 'package:lit_reader/models/favorite_lists.dart';

class ListItem extends StatelessWidget {
  const ListItem({
    super.key,
    required this.openList,
    required this.list,
  });

  final void Function(String listName, String urlname) openList;
  final Lists list;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () async {
        openList(list.title, list.urlname);
      },
      trailing: Icon(
        list.isPrivate ? Icons.lock_outlined : Icons.lock_open,
        color: list.isPrivate ? Colors.red : Colors.green,
      ),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Text(list.title),
          ),
          const SizedBox(
            width: 10,
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
            decoration: BoxDecoration(
              color: Colors.blue.shade900,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(list.storiesCount.toString()),
          )
        ],
      ),
      subtitle: Text(list.description),
    );
  }
}
