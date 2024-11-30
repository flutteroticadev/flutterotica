import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lit_reader/controllers/log_controller.dart';
import 'package:lit_reader/env/global.dart';

class LogScreen extends StatefulWidget {
  const LogScreen({super.key});

  @override
  State<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      _scrollController.addListener(() {
        if (_scrollController.offset >= _scrollController.position.maxScrollExtent) {
          logController.logsRx.listen((_) {
            _scrollController.animateTo(_scrollController.position.maxScrollExtent,
                duration: Durations.long4, curve: Curves.easeInOut);
          });
        }
      });
      // logController.logsRx.listen((_) {
      //   _scrollController.animateTo(_scrollController.position.maxScrollExtent,
      //       duration: Durations.long4, curve: Curves.easeInOut);
      // });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        titleSpacing: null,
        title: const Text('Logs'),
      ),
      body: Obx(
        () => SafeArea(
          child: Container(
            margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.vertical,
                child: Expanded(
                  child: Column(
                    children: [
                      for (LogItem log in logController.logs)
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${DateFormat('HH:mm:ss').format(log.time)}: ",
                                style: const TextStyle(color: Colors.greenAccent),
                              ),
                              Expanded(
                                child: Text(
                                  log.log,
                                  style: const TextStyle(color: Colors.white),
                                  softWrap: true,
                                  maxLines: 5000,
                                ),
                              ),
                            ],
                          ),
                        )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
