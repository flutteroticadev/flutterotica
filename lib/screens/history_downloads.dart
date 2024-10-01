import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lit_reader/env/global.dart';
import 'package:lit_reader/screens/downloads.dart';
import 'package:lit_reader/screens/history.dart';

class HistoryDownloadsScreen extends StatefulWidget {
  const HistoryDownloadsScreen({super.key});

  @override
  State<HistoryDownloadsScreen> createState() => _HistoryDownloadsScreenState();
}

class _HistoryDownloadsScreenState extends State<HistoryDownloadsScreen> {
  List<Widget> widgetOptions = <Widget>[const HistoryScreen(), const DownloadScreen()];
  @override
  Widget build(BuildContext context) {
    return Obx(() => widgetOptions.elementAt(historyDownloadController.selectedIndex));
  }
}
