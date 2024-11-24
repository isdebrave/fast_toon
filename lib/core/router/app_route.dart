import 'dart:math';

import 'package:fast_toon/features/common/presentation/pages/advanced_error_screen.dart';
import 'package:fast_toon/features/common/presentation/pages/bottom_navigation_bar_screen.dart';
import 'package:fast_toon/features/common/presentation/pages/lounge_screen.dart';
import 'package:fast_toon/features/extra_service/presentation/pages/more_screen.dart';
import 'package:fast_toon/features/payment/presentation/pages/payment_screen.dart';
import 'package:fast_toon/features/user/presentation/pages/my_screen.dart';
import 'package:fast_toon/features/user/presentation/providers/user_provider.dart';
import 'package:fast_toon/features/webtoon/presentation/pages/best_challenge_screen.dart';
import 'package:fast_toon/features/webtoon/presentation/pages/episode_screen.dart';
import 'package:fast_toon/features/webtoon/presentation/pages/recommended_screen.dart';
import 'package:fast_toon/features/webtoon/presentation/pages/webtoon_episode_list_screen.dart';
import 'package:fast_toon/features/webtoon/presentation/pages/webtoon_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final user = ref.watch(userProvider);

  return GoRouter(
    initialLocation: '/webtoon',
    navigatorKey: _rootNavigatorKey,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return BottomNavigationBarScreen(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/webtoon',
                pageBuilder: (context, state) {
                  return CustomTransitionPage(
                    key: state.pageKey,
                    child: const WebtoonScreen(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      final curvedAnimation = CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeInOut,
                        reverseCurve: Curves.easeOutBack,
                      );

                      final fadeAnimation = Tween(
                        begin: 0.0,
                        end: 1.0,
                      ).animate(curvedAnimation);

                      final slideAnimation = Tween(
                        begin: const Offset(1.0, 0.0),
                        end: Offset.zero,
                      ).animate(curvedAnimation);

                      final scaleAnimation = Tween(
                        begin: 0.5,
                        end: 1.0,
                      ).animate(curvedAnimation);

                      final rotateAnimation = Tween(
                        begin: 0.0,
                        end: 2 * pi,
                      ).animate(curvedAnimation);

                      return AnimatedBuilder(
                        animation: animation,
                        builder: (context, child) {
                          return FadeTransition(
                            opacity: fadeAnimation,
                            child: SlideTransition(
                              position: slideAnimation,
                              child: ScaleTransition(
                                scale: scaleAnimation,
                                child: Transform.rotate(
                                  angle: rotateAnimation.value,
                                  child: child,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
                routes: [
                  GoRoute(
                    path: 'episodeList/:title/:author',
                    pageBuilder: (context, state) {
                      final title = state.pathParameters['title']!;
                      final author = state.pathParameters['author']!;

                      return CustomTransitionPage(
                        key: state.pageKey,
                        child: WebtoonEpisodeListScreen(
                          title: title,
                          author: author,
                        ),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return SlideTransition(
                            position: Tween(
                              begin: const Offset(1.0, 0.0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          );
                        },
                      );
                    },
                    routes: [
                      GoRoute(
                        path: 'episode/:episodeId',
                        pageBuilder: (context, state) {
                          final episodeId = state.pathParameters['episodeId']!;

                          return CustomTransitionPage(
                            key: state.pageKey,
                            child: EpisodeScreen(id: episodeId),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              return ScaleTransition(
                                  scale: animation, child: child);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/recommended',
                pageBuilder: (context, state) {
                  return CustomTransitionPage(
                    key: state.pageKey,
                    child: const RecommendedScreen(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return RotationTransition(turns: animation, child: child);
                    },
                  );
                },
                redirect: (context, state) {
                  return '/redirect';
                },
              ),
              GoRoute(
                path: '/redirect',
                pageBuilder: (context, state) {
                  return CustomTransitionPage(
                    key: state.pageKey,
                    child: const Scaffold(
                      body: Center(child: Text('Redirecting...')),
                    ),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                  );
                },
                redirect: (context, state) {
                  return '/recommended';
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/bestChallenge',
                pageBuilder: (context, state) => CustomTransitionPage(
                  key: state.pageKey,
                  child: const BestChallengeScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.0, 1.0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    );
                  },
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/my',
                pageBuilder: (context, state) => CustomTransitionPage(
                  key: state.pageKey,
                  child: const MyScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return SizeTransition(
                      sizeFactor: animation,
                      child: child,
                    );
                  },
                ),
                redirect: (context, state) {
                  if (!user.isPremiumMember) {
                    return '/more';
                  }
                  return null;
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/more',
                pageBuilder: (context, state) => CustomTransitionPage(
                  key: state.pageKey,
                  child: const MoreScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(-1.0, 0.0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/payment',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const PaymentScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return RotationTransition(
              turns: animation,
              child: ScaleTransition(
                scale: animation,
                child: child,
              ),
            );
          },
        ),
      ),
      GoRoute(
        path: '/lounge',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const LoungeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, -1.0),
                end: Offset.zero,
              ).animate(animation),
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
        ),
        redirect: (context, state) {
          return user.isPremiumMember ? null : '/payment';
        },
      ),
    ],
    errorBuilder: (context, state) {
      return AdvancedErrorScreen(state: state);
    },
    debugLogDiagnostics: true,
  );
});
