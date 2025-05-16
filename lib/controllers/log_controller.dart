import 'package:get/get.dart';
import 'package:loggy/loggy.dart';

class LogItem {
  final String log;
  final DateTime time;

  LogItem(this.log, this.time);

  @override
  String toString() => '$time: $log';
}

class LogController extends GetxController {
  final _logs = <LogItem>[].obs;
  List<LogItem> get logs => _logs.toList();
  RxList<LogItem> get logsRx => _logs;

  int logLimit = 1000;

  void addLog(String log) {
    LogItem logItem = LogItem(log, DateTime.now());
    if (log.length > logLimit) {
      popLog();
    }
    _logs.add(logItem);
    logDebug(logItem);
  }

  void clearLogs() {
    _logs.clear();
  }

  void removeLog(int index) {
    _logs.removeAt(index);
  }

  void popLog() {
    if (logs.isNotEmpty) {
      _logs.removeAt(0);
    }
  }
}
