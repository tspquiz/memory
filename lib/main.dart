import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:memory/api/sign_api_pre_fetch.dart';
import 'package:memory/models/app_version.dart';
import 'package:memory/models/view_settings.dart';
import 'package:memory/router/router.dart';
import 'package:memory/screens/game_screen/game_screen.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final appVersion = AppVersion();
  final api = SignApiPreFetch(appVersion);
  api.preFetch(firstLevelNPairs);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ViewSettings(showVideo: true)),
      Provider.value(value: appVersion),
      Provider.value(value: api),
    ],
    child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerConfig: router,
    );
  }
}
