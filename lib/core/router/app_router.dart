import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/webtoon',
    navigatorKey: _rootNavigatorKey,
    routes: [
      ShellRoute(routes: const []),
    ],
  );
});
