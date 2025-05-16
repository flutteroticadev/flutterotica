import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutterotica/env/global.dart';
import 'package:flutterotica/screens/downloads.dart';
import 'package:flutterotica/screens/history.dart';

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
