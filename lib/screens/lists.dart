import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lit_reader/env/consts.dart';
import 'package:lit_reader/env/global.dart';
import 'package:lit_reader/screens/widgets/drawer_widget.dart';
import 'package:lit_reader/screens/widgets/lists_list_view.dart';
import 'package:lit_reader/screens/widgets/logged_in_error.dart';

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
      if (loginController.loginState == LoginState.loggedin) {
        return const Column(
          children: [
            Expanded(
              child: ListsListView(),
            ),
          ],
        );
      } else if (loginController.loginState == LoginState.loggedout || loginController.loginState == LoginState.failure) {
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
