import 'package:fast_toon/features/common/presentation/pages/lounge_screen.dart';
import 'package:fast_toon/features/extra_service/presentation/pages/more_screen.dart';
import 'package:fast_toon/features/payment/presentation/pages/payment_screen.dart';
import 'package:fast_toon/features/user/presentation/pages/my_screen.dart';
import 'package:fast_toon/features/webtoon/presentation/pages/best_challenge_screen.dart';
import 'package:fast_toon/features/webtoon/presentation/pages/recommended_screen.dart';
import 'package:fast_toon/features/webtoon/presentation/pages/webtoon_screen.dart';
import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final navigatorKey = GlobalKey<NavigatorState>();
  final RouterDelegate<AppRoutePath> _routerDelegate = AppRouteDelegate();
  final RouteInformationParser<AppRoutePath> _routerInformationParser =
      AppRouteInformationParser();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Navigator 2.0 Example',
      routerDelegate: _routerDelegate,
      routeInformationParser: _routerInformationParser,
    );
  }
}

class AppRoutePath {
  final String? location;

  AppRoutePath({this.location});

  bool get isWebtoon => location == '/webtoon';
  bool get isRecommended => location == '/recommended';
  bool get isBestChallenge => location == '/bestChallenge';
  bool get isMy => location == '/my';
  bool get isMore => location == '/more';
  bool get isPayment => location == '/payment';
  bool get isLounge => location == '/lounge';
}

class AppRouteInformationParser extends RouteInformationParser<AppRoutePath> {
  @override
  Future<AppRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = routeInformation.uri;

    if (uri.pathSegments.isEmpty) {
      return AppRoutePath(location: '/webtoon');
    }

    return AppRoutePath(location: '/${uri.pathSegments.first}');
  }

  @override
  RouteInformation? restoreRouteInformation(AppRoutePath configuration) {
    return RouteInformation(uri: Uri.parse(configuration.location!));
  }
}

class AppRouteDelegate extends RouterDelegate<AppRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoutePath> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  AppRouteDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  String? _currentLocation = '/webtoon';

  @override
  AppRoutePath get currentConfiguration {
    return AppRoutePath(location: _currentLocation);
  }

  @override
  Future<void> setNewRoutePath(AppRoutePath configuration) async {
    _currentLocation = configuration.location;
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        if (_currentLocation == '/webtoon')
          const MaterialPage(
            key: ValueKey('WebtoonScreen'),
            child: WebtoonScreen(),
          )
        else if (_currentLocation == '/recommended')
          const MaterialPage(
            key: ValueKey('RecommendedScreen'),
            child: RecommendedScreen(),
          )
        else if (_currentLocation == '/bestChallenge')
          const MaterialPage(
            key: ValueKey('BestChallengeScreen'),
            child: BestChallengeScreen(),
          )
        else if (_currentLocation == '/my')
          const MaterialPage(
            key: ValueKey('MyScreen'),
            child: MyScreen(),
          )
        else if (_currentLocation == '/more')
          const MaterialPage(
            key: ValueKey('MoreScreen'),
            child: MoreScreen(),
          )
        else if (_currentLocation == '/payment')
          const MaterialPage(
            key: ValueKey('PaymentScreen'),
            child: PaymentScreen(),
          )
        else if (_currentLocation == '/lounge')
          const MaterialPage(
            key: ValueKey('LoungeScreen'),
            child: LoungeScreen(),
          )
      ],
      onDidRemovePage: (page) {
        if (!page.canPop) {
          return;
        }

        _currentLocation = '/webtoon';
        notifyListeners();
      },
    );
  }
}
