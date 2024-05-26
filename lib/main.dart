import 'package:flutter/material.dart';

import 'package:expanse_tracker/app/app.locator.dart';
import 'package:expanse_tracker/app/app.router.dart';
import 'package:flutter/services.dart';
import 'package:stacked_services/stacked_services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.blueAccent,
    ));
    final colorScheme =
        const ColorScheme.light().copyWith(primary: Colors.black);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.loginView,
      onGenerateRoute: StackedRouter().onGenerateRoute,
      navigatorKey: StackedService.navigatorKey,
      navigatorObservers: [
        StackedService.routeObserver,
      ],
      theme: ThemeData(
          colorScheme: colorScheme,
          scaffoldBackgroundColor: Colors.grey,
          appBarTheme: const AppBarTheme(backgroundColor: Colors.blueAccent)),
    );
  }
}
