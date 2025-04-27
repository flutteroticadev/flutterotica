import 'package:flutter/material.dart';
import 'package:lit_reader/controllers/search_controller.dart' as lit_controller;
import 'package:lit_reader/env/colors.dart';
import 'package:lit_reader/env/global.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

class LitMultiCategories extends StatefulWidget {
  const LitMultiCategories({
    super.key,
    required this.searchController,
  });
  final lit_controller.SearchController searchController;

  @override
  State<LitMultiCategories> createState() => _LitMultiCategoriesState();
}

class _LitMultiCategoriesState extends State<LitMultiCategories> {
  String? selectValue;
  List<ValueItem> categoryItems = [];
  final MultiSelectController _controller = MultiSelectController();

  @override
  void initState() {
    super.initState();
    // print(categories.length);
    // categories.sort((a, b) => a.name.compareTo(b.name));
    categoryItems = [
      ...litSearchController.categories.map((cat) => ValueItem(value: cat.id.toString(), label: cat.name)).toList()
    ];
    ValueItem? allCatItem = categoryItems.where((cat) => cat.value == "1").firstOrNull;
    if (allCatItem != null && categoryItems.indexOf(allCatItem) != 0) {
      categoryItems.removeAt(categoryItems.indexOf(allCatItem));
      categoryItems.insert(0, allCatItem);
    }

    selectValue = categoryItems.firstOrNull?.value ?? "1";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Categories"),
        const SizedBox(height: 20),
        MultiSelectDropDown(
          // showClearIcon: false,
          controller: _controller,
          onOptionSelected: (options) {
            widget.searchController.selectedCategory = [
              ...options.where((option) => option.value != "1").map((option) => option.value).toList()
            ];
          },
          options: categoryItems,
          selectedOptions: [
            ...categoryItems
                .where((cat) => widget.searchController.selectedCategory.isNotEmpty
                    ? (widget.searchController.selectedCategory.contains(cat.value) && cat.value != "1")
                    : cat.value == "1")
                .toList()
          ],
          selectedOptionTextColor: Colors.white,
          selectedOptionBackgroundColor: kRed,
          optionsBackgroundColor: Colors.black87,
          // backgroundColor: Colors.transparent,
          fieldBackgroundColor: Colors.transparent,
          selectionType: !widget.searchController.searchTags ? SelectionType.multi : SelectionType.single,
          chipConfig: const ChipConfig(
            wrapType: WrapType.wrap,
            runSpacing: 0,
            padding: EdgeInsets.all(5),
            backgroundColor: kRed,
          ),
          dropdownHeight: 300,
          borderRadius: 5,
          optionTextStyle: const TextStyle(fontSize: 16, color: Colors.white),
          selectedOptionIcon: const Icon(Icons.check_circle),
        ),
      ],
    );
  }
}
