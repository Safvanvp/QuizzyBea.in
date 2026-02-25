import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quizzybea_in/core/app_routes.dart';
import 'package:quizzybea_in/screens/auth/login_page.dart';
import 'package:quizzybea_in/screens/auth/register_page.dart';
import 'package:quizzybea_in/screens/home/home_page.dart';
import 'package:quizzybea_in/screens/introduction/introduction_page.dart';
import 'package:quizzybea_in/screens/leaderboard/leaderboard_page.dart';
import 'package:quizzybea_in/screens/quiz/quiz_screen.dart';
import 'package:quizzybea_in/screens/settings/edit_profile_page.dart';
import 'package:quizzybea_in/screens/settings/settings_page.dart';
import 'package:quizzybea_in/screens/shell/main_shell.dart';
import 'package:quizzybea_in/screens/splash/splash_screen.dart';
import 'package:quizzybea_in/screens/history/quiz_history_page.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static GoRouter get router => GoRouter(
        navigatorKey: _rootNavigatorKey,
        initialLocation: AppRoutes.splash,
        redirect: (context, state) {
          final user = FirebaseAuth.instance.currentUser;
          final loc = state.matchedLocation;
          final publicRoutes = {
            AppRoutes.login,
            AppRoutes.register,
            AppRoutes.introduction,
            AppRoutes.splash,
          };
          if (user == null && !publicRoutes.contains(loc)) {
            return AppRoutes.introduction;
          }
          return null;
        },
        routes: [
          GoRoute(
            path: AppRoutes.splash,
            builder: (c, s) => const SplashScreen(),
          ),
          GoRoute(
            path: AppRoutes.introduction,
            builder: (c, s) => const IntroductionPage(),
          ),
          GoRoute(
            path: AppRoutes.login,
            builder: (c, s) => const LoginPage(),
          ),
          GoRoute(
            path: AppRoutes.register,
            builder: (c, s) => const RegisterPage(),
          ),
          GoRoute(
            path: AppRoutes.editProfile,
            builder: (c, s) => const EditProfilePage(),
          ),
          GoRoute(
            path: AppRoutes.quiz,
            builder: (c, s) {
              final category = s.extra as String? ?? '';
              return QuizScreen(category: category);
            },
          ),
          ShellRoute(
            navigatorKey: _shellNavigatorKey,
            builder: (c, s, child) => MainShell(child: child),
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (c, s) => const HomePage(),
              ),
              // GoRoute(
              //   path: AppRoutes.leaderboard,
              //   builder: (c, s) => const LeaderboardPage(),
              // ),
              GoRoute(
                path: AppRoutes.history,
                builder: (c, s) => const QuizHistoryPage(),
              ),
              GoRoute(
                path: AppRoutes.settings,
                builder: (c, s) => const SettingsPage(),
              ),
            ],
          ),
        ],
      );
}
