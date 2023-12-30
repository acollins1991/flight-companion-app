import 'package:firebase_auth/firebase_auth.dart';
import 'package:flight_companion_app/state/user.dart';
import 'package:flight_companion_app/views/chat_screen.dart';
import 'package:flight_companion_app/views/home_screen.dart';
import 'package:flight_companion_app/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// The route configuration.
final GoRouter router = GoRouter(
  // protect routes from unauth
  redirect: (BuildContext context, GoRouterState state) {
    if (state.name != 'login.index' && !isAuthenticated) {
      return '/login';
    } else if (state.name == 'login.index' && isAuthenticated) {
      return '/';
    }
    return null;
  },
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      name: 'index',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeView();
      },
      routes: <RouteBase>[
        GoRoute(
            path: 'login',
            name: 'login.index',
            builder: (BuildContext context, GoRouterState state) {
              return const LoginView();
            }),
        GoRoute(
          path: 'chat',
          name: 'chat.index',
          builder: (BuildContext context, GoRouterState state) {
            return const ChatPage();
          },
        ),
      ],
    ),
  ],
);
