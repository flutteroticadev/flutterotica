import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:lit_reader/controllers/search_controller.dart' as litController;
import 'package:lit_reader/env/colors.dart';
import 'package:lit_reader/models/submission.dart';

class LitSearchTagBar extends StatefulWidget {
  const LitSearchTagBar({
    super.key,
    required this.formKey,
    this.initialValue,
    this.litSearchController,
    this.onChanged,
    this.margin = 10,
    required this.pagingController,
    this.searchFieldTextController,
  });

  final GlobalKey<FormState> formKey;
  final String? initialValue;
  final PagingController<int, Submission> pagingController;
  final TextEditingController? searchFieldTextController;

  final litController.SearchController? litSearchController;
  final void Function()? onChanged;
  final double margin;

  @override
  State<LitSearchTagBar> createState() => _LitSearchTagBarState();
}

class _LitSearchTagBarState extends State<LitSearchTagBar> {
  late TextEditingController searchController;
  @override
  void initState() {
    searchController = widget.searchFieldTextController ?? TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // searchController!.text = initialValue!;

    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: widget.margin * 1.5, right: widget.margin * 0.2, bottom: 4),
                  child: const Text('Tags:'),
                ),
                if (widget.litSearchController != null)
                  Obx(
                    () => Container(
                      margin: EdgeInsets.symmetric(horizontal: widget.margin),
                      child: Wrap(
                        spacing: 8,
                        children: widget.litSearchController!.tagList
                            .map((tag) => Chip(
                                  side: const BorderSide(color: kred),
                                  backgroundColor: kred,
                                  label: Text(tag),
                                  onDeleted: () {
                                    widget.litSearchController!.tagList.remove(tag);
                                    widget.litSearchController!.refresh();
                                  },
                                ))
                            .toList(),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10.0),
            ),
            margin: EdgeInsets.symmetric(horizontal: widget.margin),
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: TextFormField(
                controller: searchController,
                textInputAction: TextInputAction.search,
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 3) {
                    return 'Please enter atleast 3 characters';
                  }
                  return null;
                },
                onChanged: (value) {
                  if (value.endsWith(",")) {
                    if (value.trim().isNotEmpty && value.trim().length > 2) {
                      if (widget.litSearchController!.tagList.contains(value.trim()) == false) {
                        widget.litSearchController!.tagList.add(value.trim().replaceAll(",", ""));
                      }

                      searchController.clear();
                    }
                  }
                },
                onFieldSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    if (widget.formKey.currentState!.validate() && widget.litSearchController != null) {
                      widget.litSearchController!.tagList.add(value.trim());

                      searchController.clear();
                    }
                  } else {
                    searchController.clear();
                    widget.pagingController.refresh();
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Search',
                  border: InputBorder.none,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      if (searchController.text.isNotEmpty) {
                        searchController.clear();
                      } else {
                        widget.litSearchController?.tagList.clear();
                      }

                      widget.onChanged!();
                    },
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
