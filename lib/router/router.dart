import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:memory/screens/game_screen/game_screen.dart';
import 'package:memory/screens/start_screen/start_screen.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const StartScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'game',
          builder: (BuildContext context, GoRouterState state) {
            return const GameScreen();
          },
        ),
      ],
    ),
  ],
);
