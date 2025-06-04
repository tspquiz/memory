import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:memory/api/sign_api_pre_fetch.dart';
import 'package:memory/models/view_settings.dart';
import 'package:memory/router/router.dart';
import 'package:memory/screens/game_screen/game_screen.dart';
import 'package:memory/theme/app_theme.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final api = SignApiPreFetch();
  api.preFetch(firstLevelNPairs);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ViewSettings(showVideo: true)),
      Provider.value(value: api),
      Provider<CacheManager?>(create: (_) => kIsWeb ? null : DefaultCacheManager()),
    ],
    child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'TSP Memory',
      theme: appTheme,
      routerConfig: router,
    );
  }
}
