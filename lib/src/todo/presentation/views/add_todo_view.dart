import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/todo_list.dart';
import '../bloc/todo_list_bloc.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  @override
  AddTodoPageState createState() => AddTodoPageState();
}

class AddTodoPageState extends State<AddTodoPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();

  final auth = FirebaseAuth.instance;

  void _createTodoList(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final todoList = TodoList(
        id: '',
        title: _titleController.text,
        userId: auth.currentUser!.uid,
        createdAt: DateTime.now(),
      );

      context.read<TodoListBloc>().add(CreateTodoListEvent(todoList));

      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Lista')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration:
                    const InputDecoration(labelText: 'Título de la lista'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa un título';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              BlocConsumer<TodoListBloc, TodoListState>(
                listener: (context, state) {
                  if (state is TodoListsLoaded) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Lista creada correctamente")),
                    );
                    context.pop();
                  }
                  if (state is TodoListError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  }
                },
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: state is TodoListLoading
                        ? null
                        : () => _createTodoList(context),
                    child: state is TodoListLoading
                        ? const CircularProgressIndicator()
                        : const Text("Guardar"),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
