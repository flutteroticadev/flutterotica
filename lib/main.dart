import 'package:flutter/material.dart';
import 'package:flutter_loggy/flutter_loggy.dart';
import 'package:flutterotica/controllers/dio_controller.dart';
import 'package:flutterotica/controllers/history_download_screen_controller.dart';
import 'package:flutterotica/controllers/lists_controller.dart';
import 'package:flutterotica/controllers/log_controller.dart';
import 'package:flutterotica/controllers/login_controller.dart';
import 'package:flutterotica/controllers/search_controller.dart' as search_controller;
import 'package:flutterotica/env/colors.dart';
import 'package:flutterotica/env/consts.dart';
import 'package:flutterotica/env/global.dart';
import 'package:flutterotica/screens/home.dart';
import 'package:loggy/loggy.dart';
import 'package:overlay_support/overlay_support.dart';

Future<void> main() async {
  Loggy.initLoggy(
    logPrinter: const PrettyDeveloperPrinter(),
  );

  WidgetsFlutterBinding.ensureInitialized();
  await initSharedPreferences();
  _initServices();

  runApp(const OverlaySupport(child: MyApp()));
}

_initServices() {
  try {
    ioc.registerSingleton<LogController>(LogController());
    ioc.registerSingleton<DioController>(DioController());
    ioc.registerSingleton<LoginController>(LoginController());
    ioc.registerSingleton<search_controller.SearchController>(search_controller.SearchController());
    ioc.registerSingleton<HistoryDownloadController>(HistoryDownloadController());
    ioc.registerSingleton<ListController>(ListController());
  } catch (e) {
    logError(e);
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void> initPrefs() async {
    loginController.username = preferences.getString('username') ?? '';
    loginController.password = preferences.getString('password') ?? '';
    loginController.token = loginController.token.copyWith(token: preferences.getString('token') ?? '');
    if (await loginController.isTokenValid()) {
      loginController.loginState = LoginState.loggedIn;
    } else if (loginController.username.isNotEmpty && loginController.password.isNotEmpty) {
      loginController.refreshToken();
    } else {
      loginController.loginState = LoginState.loggedOut;
    }
    await litSearchController.getCategories();
    litSearchController.selectedCategory = prefsFunctions.getSearchCategories();
  }

  @override
  void initState() {
    super.initState();

    initPrefs();
    logController.addLog('App started');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: globalNavigatorKey,
      title: 'Flutterotica',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: kRed),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
