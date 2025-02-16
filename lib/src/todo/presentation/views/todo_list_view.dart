import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:to_doey/src/todo/presentation/bloc/todo_list_bloc.dart';

class TodoListView extends StatelessWidget {
  const TodoListView({super.key});

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
                ? Center(child: Text('No hay listas de tareas creadas'))
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
                              if (todoList.items.isEmpty)
                                const Text("No hay tareas aún.")
                              else
                                Column(
                                  children: todoList.items.map((item) {
                                    return ListTile(
                                      title: Text(item.description),
                                      leading: Checkbox(
                                        value: item.isCompleted,
                                        onChanged: (value) {},
                                      ),
                                    );
                                  }).toList(),
                                ),
                              InkWell(
                                onTap: () {
                                  context.push('/add-todo-item/${todoList.id}');
                                },
                                child: const Text("Agregar tarea"),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}
