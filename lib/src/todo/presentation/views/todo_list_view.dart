import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:to_doey/src/todo/data/repositories/todo_list_repository.dart';
import 'package:to_doey/src/todo/domain/entities/todo_item.dart';
import 'package:to_doey/src/todo/presentation/bloc/todo_list_bloc.dart';

class TodoListView extends StatefulWidget {
  const TodoListView({super.key});

  @override
  State<TodoListView> createState() => _TodoListViewState();
}

class _TodoListViewState extends State<TodoListView> {
  final Map<String, bool> _showTranslation = {};

  @override
  Widget build(BuildContext context) {
    return BlocListener<TodoListBloc, TodoListState>(
      listener: (context, state) {
        if (state is TodoListError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: BlocBuilder<TodoListBloc, TodoListState>(
        builder: (context, state) {
          if (state is TodoListLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TodoListError) {
            return Center(child: Text(state.message));
          } else if (state is TodoListsLoaded) {
            return state.todoLists.isEmpty
                ? const Center(child: Text('No hay listas de tareas creadas'))
                : ListView.builder(
                    itemCount: state.todoLists.length,
                    itemBuilder: (context, index) {
                      final todoList = state.todoLists[index];

                      return Card(
                        margin: const EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                todoList.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              StreamBuilder<List<TodoItem>>(
                                stream: context
                                    .read<TodoListRepository>()
                                    .getTodosItems(todoList.id),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return const Text(
                                        "Error al cargar tareas.");
                                  }

                                  final items = snapshot.data ?? [];
                                  if (items.isEmpty) {
                                    return const Text("No hay tareas aún.");
                                  }

                                  return Column(
                                    children: items.map((item) {
                                      final bool showTranslation =
                                          _showTranslation[item.id] ?? false;
                                      final String displayedText =
                                          (showTranslation &&
                                                  item.translation.isNotEmpty)
                                              ? item.translation
                                              : item.description;

                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ListTile(
                                            title: Text(
                                              displayedText,
                                              style: TextStyle(
                                                decoration: item.isCompleted
                                                    ? TextDecoration.lineThrough
                                                    : TextDecoration.none,
                                              ),
                                            ),
                                            leading: Checkbox(
                                              value: item.isCompleted,
                                              onChanged: (value) {
                                                final updatedTodo =
                                                    item.copyWith(
                                                        isCompleted: value);
                                                context
                                                    .read<TodoListBloc>()
                                                    .add(
                                                      UpdateTodoItem(
                                                          todoList.id,
                                                          updatedTodo),
                                                    );
                                              },
                                            ),
                                            trailing: IconButton(
                                              icon: const Icon(Icons.delete),
                                              onPressed: () {
                                                context
                                                    .read<TodoListBloc>()
                                                    .add(
                                                      DeleteTodoItem(
                                                          todoList.id, item),
                                                    );
                                              },
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                _showTranslation[item.id] =
                                                    !showTranslation;
                                              });
                                            },
                                            child: Text(
                                              showTranslation
                                                  ? 'Mostrar Original'
                                                  : 'Mostrar Traducción',
                                              style: const TextStyle(
                                                color: Colors.blueAccent,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10)
                                        ],
                                      );
                                    }).toList(),
                                  );
                                },
                              ),
                              InkWell(
                                onTap: () {
                                  context.push('/add-todo-item/${todoList.id}');
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.add,
                                        color: Colors.deepPurple),
                                    const SizedBox(width: 10),
                                    const Text('ADD TODO'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
          }
          return const Text('no data');
        },
      ),
    );
  }
}
