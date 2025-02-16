import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:to_doey/src/auth/data/repositories/auth_repository_impl.dart';
import 'package:to_doey/src/todo/data/repositories/todo_list_repository.dart';
import 'package:to_doey/src/todo/presentation/bloc/todo_list_bloc.dart';
import 'package:to_doey/src/todo/presentation/views/todo_list_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de tareas'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded))
        ],
      ),
      body: BlocProvider(
        create: (context) => TodoListBloc(
          repository: RepositoryProvider.of<TodoListRepository>(context),
          authRepository: RepositoryProvider.of<AuthRepositoryImpl>(context),
        )..add(LoadTodos()),
        child: TodoListView(),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          context.push('/add-todo');
        },
      ),
    );
  }
}
