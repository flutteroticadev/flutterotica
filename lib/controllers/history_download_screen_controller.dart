import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HistoryDownloadController extends GetxController {
  final _selectedIndex = 0.obs;
  final _selectedTabName = 'History'.obs;
  final _selectedTabIcon = const Icon(Icons.history).obs;

  int get selectedIndex => _selectedIndex.value;
  set selectedIndex(int value) => _selectedIndex.value = value;

  String get selectedTabName => _selectedTabName.value;
  set selectedTabName(String value) => _selectedTabName.value = value;

  Icon get selectedTabIcon => _selectedTabIcon.value;
  set selectedTabIcon(Icon value) => _selectedTabIcon.value = value;
}
