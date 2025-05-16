import 'package:flutter/material.dart';
import 'package:flutterotica/env/global.dart';

class LitCategories extends StatefulWidget {
  const LitCategories({
    super.key,
  });

  @override
  State<LitCategories> createState() => _LitCategoriesState();
}

class _LitCategoriesState extends State<LitCategories> {
  String? selectValue;
  List<DropdownMenuItem<String>> categoryItems = [];

  @override
  @override
  void initState() {
    super.initState();
    //  litSearchController.categories.sort((a, b) => a.name.compareTo(b.name));
    categoryItems = [
      ...litSearchController.categories
          .map((cat) => DropdownMenuItem<String>(value: cat.id.toString(), child: Flexible(child: Text(cat.name))))
          .toList()
    ];
    DropdownMenuItem<String> itemToMove =
        categoryItems.removeAt(categoryItems.indexOf(categoryItems.where((cat) => cat.value == "1").first));
    categoryItems.insert(0, itemToMove);
    selectValue = "1";
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text("Category"),
        const SizedBox(width: 10),
        Expanded(
          child: DropdownButton<String>(
            isExpanded: true,
            value: selectValue,
            onChanged: (String? newValue) {
              setState(() {
                selectValue = newValue;
              });
            },
            items: categoryItems,
          ),
        ),
      ],
    );
  }
}
