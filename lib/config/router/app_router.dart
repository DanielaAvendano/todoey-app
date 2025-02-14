import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:to_doey/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:to_doey/src/auth/presentation/views/auth_page.dart';
import 'package:to_doey/src/todo/presentation/views/add_todo_page.dart';
import 'package:to_doey/src/todo/presentation/views/home_page.dart';

class AppRouter {
  final AuthBloc authBloc;

  AppRouter(this.authBloc);

  late final GoRouter router = GoRouter(
    initialLocation: '/signin',
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    routes: [
      ///* Auth Routes
      GoRoute(
        path: '/signin',
        builder: (context, state) => const AuthPage(),
      ),

      ///* Home Routes
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/add-todo',
        builder: (context, state) => const AddTodoPage(),
      ),
    ],
    redirect: (context, state) {
      final isGoingTo = state.uri.toString();
      final authState = authBloc.state;

      print("Estado de autenticación: $authState");
      print("Ruta solicitada: $isGoingTo");

      if (authState is! Authenticated && isGoingTo != '/signin') {
        return '/signin';
      }

      if (authState is Authenticated && isGoingTo == '/signin') {
        return '/';
      }
      return null;
    },
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream stream) {
    notifyListeners();
    stream.listen((_) {
      notifyListeners();
    });
  }
}
