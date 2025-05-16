import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:flutterotica/classes/api.dart';
import 'package:flutterotica/classes/db_functions.dart';
import 'package:flutterotica/classes/prefs_functions.dart';
import 'package:flutterotica/classes/search_config.dart';
import 'package:flutterotica/controllers/dio_controller.dart';
import 'package:flutterotica/controllers/history_download_screen_controller.dart';
import 'package:flutterotica/controllers/lists_controller.dart';
import 'package:flutterotica/controllers/log_controller.dart';
import 'package:flutterotica/controllers/login_controller.dart';
import 'package:flutterotica/controllers/search_controller.dart' as search_controller;
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:shared_preferences/shared_preferences.dart';

// This needs refactoring. There are at least 3 types of singletons in this app...
GlobalKey<NavigatorState> globalNavigatorKey = GlobalKey<NavigatorState>();
final ioc = GetIt.instance;

DbFunctions dbFunctions = DbFunctions();

PrefsFunctions prefsFunctions = PrefsFunctions();

API api = API();

late SharedPreferences preferences;

Future<void> initSharedPreferences() async {
  preferences = await SharedPreferences.getInstance();
}

PersistentTabController persistentTabController = PersistentTabController(initialIndex: 2);

navigateToSearch(SearchConfig searchConfig) {
  litSearchController.categorySearch = searchConfig.isCategorySearch;
  litSearchController.newOnly = searchConfig.newOnly;
  litSearchController.random = searchConfig.random;
  litSearchController.categorySearchId = searchConfig.selectedCategory.first;
  litSearchController.searchTags = searchConfig.isTagSearch;
  litSearchController.tagList = searchConfig.tagList ?? [];
  litSearchController.searchTerm = searchConfig.searchTerm ?? "";
  litSearchController.sortOrder = searchConfig.sortOrder;
  litSearchController.sortString = searchConfig.sortString;
  litSearchController.isPopular = searchConfig.isPopular;
  litSearchController.isWinner = searchConfig.isWinner;
  litSearchController.isEditorsChoice = searchConfig.isEditorsChoice;

  persistentTabController.jumpToTab(2);
}

LogController get logController => Get.put(LogController());
DioController get dioController => Get.put(DioController());
LoginController get loginController => Get.put(LoginController());
search_controller.SearchController get litSearchController => Get.put(search_controller.SearchController());
HistoryDownloadController get historyDownloadController => Get.put(HistoryDownloadController());
ListController get listController => Get.put(ListController());
