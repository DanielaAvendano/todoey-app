import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:to_doey/src/auth/domain/repos/auth_repo.dart';
import 'package:to_doey/src/todo/data/repositories/todo_list_repository.dart';
import 'package:to_doey/src/todo/domain/entities/todo_item.dart';
import 'package:to_doey/src/todo/domain/entities/todo_list.dart';

part 'todo_list_event.dart';
part 'todo_list_state.dart';

class TodoListBloc extends Bloc<TodoListEvent, TodoListState> {
  TodoListBloc({
    required TodoListRepository repository,
    required AuthRepository authRepository,
  })  : _repository = repository,
        super(TodoListInitial()) {
    on<CreateTodoListEvent>(_onCreateTodoList);
    on<AddTodoItemEvent>(_onAddTodoItem);
    on<LoadTodos>(_onLoadTodos);
    on<TodoListsUpdated>(_onTodoListsUpdated);
  }

  final TodoListRepository _repository;
  late StreamSubscription _todoListSubscription;

  Future<void> _onLoadTodos(
      LoadTodos event, Emitter<TodoListState> emit) async {
    emit(TodoListLoading());
    try {
      _todoListSubscription = _repository.getTodos().listen((todoLists) {
        add(TodoListsUpdated(todoLists));
      });
    } catch (e) {
      emit(TodoListError("Error al cargar las listas de tareas"));
    }
  }

  void _onTodoListsUpdated(
      TodoListsUpdated event, Emitter<TodoListState> emit) {
    emit(TodoListsLoaded(event.todoLists));
  }

  Future<void> _onCreateTodoList(
      CreateTodoListEvent event, Emitter<TodoListState> emit) async {
    emit(TodoListLoading());
    try {
      await _repository.createTodoList(event.todoList);
      add(LoadTodos());
      emit(TodoOperationSuccess('Todo updated successfully.'));
    } catch (e) {
      emit(TodoListError("Error al crear la lista de tareas"));
    }
  }

  Future<void> _onAddTodoItem(
      AddTodoItemEvent event, Emitter<TodoListState> emit) async {
    try {
      await _repository.addTodoItem(event.listId, event.todoItem);
      add(LoadTodos());
    } catch (e) {
      emit(TodoListError("Error al agregar la tarea"));
    }
  }

  @override
  Future<void> close() {
    _todoListSubscription.cancel();
    return super.close();
  }
}
