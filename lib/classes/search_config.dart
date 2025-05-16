import 'package:flutterotica/env/consts.dart';

class SearchConfig {
  final bool isTagSearch;
  final bool isCategorySearch;
  final bool isPopular;
  final bool isWinner;
  final bool isEditorsChoice;
  final SearchSortField sortOrder;
  final String? sortString;
  final List<int> selectedCategory;
  final List<String>? tagList;
  final String? searchTerm;
  final bool newOnly;
  final bool random;

  SearchConfig({
    this.isTagSearch = false,
    this.isCategorySearch = false,
    required this.isPopular,
    required this.isWinner,
    required this.isEditorsChoice,
    required this.sortOrder,
    this.sortString,
    required this.selectedCategory,
    this.tagList,
    this.searchTerm,
    this.newOnly = false,
    this.random = false,
  });

  factory SearchConfig.tagSearch({
    required List<String> tagList,
    bool isPopular = false,
    bool isWinner = false,
    bool isEditorsChoice = false,
    SearchSortField sortOrder = SearchSortField.relevant,
    String? sortString = SearchString.relevant,
    int selectedCategory = 1,
  }) {
    return SearchConfig(
      isTagSearch: true,
      isPopular: isPopular,
      isWinner: isWinner,
      isEditorsChoice: isEditorsChoice,
      sortOrder: sortOrder,
      sortString: sortString,
      selectedCategory: [selectedCategory],
      tagList: tagList,
    );
  }

  factory SearchConfig.termSearch({
    required String searchTerm,
    bool isPopular = false,
    bool isWinner = false,
    bool isEditorsChoice = false,
    SearchSortField sortOrder = SearchSortField.relevant,
    String? sortString = SearchString.relevant,
    int selectedCategory = 1,
  }) {
    return SearchConfig(
      isPopular: isPopular,
      isWinner: isWinner,
      isEditorsChoice: isEditorsChoice,
      sortOrder: sortOrder,
      sortString: sortString,
      selectedCategory: [selectedCategory],
      searchTerm: searchTerm,
    );
  }

  factory SearchConfig.categorySearch({
    bool isPopular = false,
    bool isWinner = false,
    bool isEditorsChoice = false,
    SearchSortField sortOrder = SearchSortField.relevant,
    String? sortString = SearchString.relevant,
    int? selectedCategory = 1,
    bool newOnly = false,
    bool random = false,
  }) {
    return SearchConfig(
      isCategorySearch: true,
      isPopular: isPopular,
      isWinner: isWinner,
      isEditorsChoice: isEditorsChoice,
      sortOrder: sortOrder,
      sortString: sortString,
      selectedCategory: [selectedCategory!],
      newOnly: newOnly,
      random: random,
    );
  }
}
