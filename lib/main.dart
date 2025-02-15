import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_doey/config/config.dart';

import 'package:to_doey/firebase_options.dart';
import 'package:to_doey/src/auth/data/datasources/firebase_auth_service.dart';
import 'package:to_doey/src/auth/data/repositories/auth_repository_impl.dart';
import 'package:to_doey/src/todo/data/repositories/todo_list_repository.dart';

import 'package:to_doey/src/auth/domain/usecases/sign_in_anonim.dart';
import 'package:to_doey/src/auth/presentation/bloc/auth_bloc.dart';

import 'package:to_doey/src/todo/presentation/bloc/todo_list_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final authService = FirebaseAuthService();
  final authRepository = AuthRepositoryImpl(authService);
  final signInAnonymously = SignInAnonymously(authRepository);
  final authBloc = AuthBloc(signInAnonymously);

  final appRouter = AppRouter(authBloc);

  final todoListRepository = TodoListRepository();
  final todoListBloc = TodoListBloc(todoListRepository);

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthBloc>.value(value: authBloc),
        RepositoryProvider<AppRouter>.value(value: appRouter),
        RepositoryProvider<TodoListBloc>.value(value: todoListBloc),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = RepositoryProvider.of<AppRouter>(context);

    return MaterialApp.router(
      title: 'Todo App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
      ),
      routerConfig: appRouter.router,
    );
  }
}
