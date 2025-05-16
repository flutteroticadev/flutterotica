import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutterotica/env/consts.dart';
import 'package:flutterotica/env/global.dart';
import 'package:flutterotica/screens/widgets/drawer_widget.dart';
import 'package:flutterotica/screens/widgets/lists_list_view.dart';
import 'package:flutterotica/screens/widgets/logged_in_error.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBar(
        title: const Text('Lists'),
      ),
      body: body(),
    );
  }

  Widget body() {
    return Obx(() {
      if (loginController.loginState == LoginState.loggedIn) {
        return const Column(
          children: [
            Expanded(
              child: ListsListView(),
            ),
          ],
        );
      } else if (loginController.loginState == LoginState.loggedOut || loginController.loginState == LoginState.failure) {
        return const LoggedInError(
          text: "You must be logged in to view your lists",
        );
      } else {
        return const Expanded(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
    });
  }
}
