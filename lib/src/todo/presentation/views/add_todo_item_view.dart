import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_doey/src/todo/presentation/bloc/todo_list_bloc.dart';
import '../../domain/entities/todo_item.dart';

class AddTodoItemPage extends StatefulWidget {
  final String todoListId;
  const AddTodoItemPage({super.key, required this.todoListId});

  @override
  AddTodoItemPageState createState() => AddTodoItemPageState();
}

class AddTodoItemPageState extends State<AddTodoItemPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();

  void _addTodoItem(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final todoItem = TodoItem(
        id: '',
        description: _descriptionController.text,
        isCompleted: false,
      );

      context
          .read<TodoListBloc>()
          .add(AddTodoItemEvent(widget.todoListId, todoItem));
      _descriptionController.clear();

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Item')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _descriptionController,
                decoration:
                    const InputDecoration(labelText: 'Descripción de la tarea'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa una descripción';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _addTodoItem(context),
                child: const Text("Agregar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
