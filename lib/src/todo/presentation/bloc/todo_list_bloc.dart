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
    on<LoadTodosItems>(_onLoadTodosItems);
    on<TodoListsUpdated>(_onTodoListsUpdated);
    on<TodoItemsUpdated>(_onTodoItemsUpdated);
    on<UpdateTodoItem>(_onUpdateTodoItem);
    on<DeleteTodoItem>(_onDeleteTodoItem);
  }

  final TodoListRepository _repository;
  late StreamSubscription _todoListSubscription;
  late StreamSubscription _todoItemsSubscription;

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

  Future<void> _onLoadTodosItems(
      LoadTodosItems event, Emitter<TodoListState> emit) async {
    emit(TodoListLoading());
    try {
      _todoItemsSubscription =
          _repository.getTodosItems(event.listId).listen((todoItems) {
        add(TodoItemsUpdated(todoItems));
      });
    } catch (e) {
      emit(TodoListError("Error al cargar las listas de tareas"));
    }
  }

  void _onTodoListsUpdated(
      TodoListsUpdated event, Emitter<TodoListState> emit) {
    emit(TodoListsLoaded(event.todoLists));
  }

  void _onTodoItemsUpdated(
      TodoItemsUpdated event, Emitter<TodoListState> emit) {
    if (event.todoItems.isEmpty) {
      emit(TodoItemsEmpty());
    } else {
      emit(TodoItemsLoaded(event.todoItems));
    }
  }

  Future<void> _onCreateTodoList(
      CreateTodoListEvent event, Emitter<TodoListState> emit) async {
    emit(TodoListLoading());
    try {
      await _repository.createTodoList(event.todoList);
      emit(TodoOperationSuccess('Todo updated successfully.'));
    } catch (e) {
      emit(TodoListError("Error al crear la lista de tareas"));
    }
  }

  Future<void> _onAddTodoItem(
      AddTodoItemEvent event, Emitter<TodoListState> emit) async {
    try {
      await _repository.addTodoItem(event.listId, event.todoItem);
    } catch (e) {
      emit(TodoListError("Error al agregar la tarea"));
    }
  }

  Future<void> _onUpdateTodoItem(
      UpdateTodoItem event, Emitter<TodoListState> emit) async {
    try {
      await _repository.updateTodoItem(event.listId, event.todoItem);
    } catch (e) {
      emit(TodoListError("Error al actualizar la tarea"));
    }
  }

  Future<void> _onDeleteTodoItem(
      DeleteTodoItem event, Emitter<TodoListState> emit) async {
    try {
      await _repository.deleteTodoItem(event.listId, event.itemId);
    } catch (e) {
      emit(TodoListError("Error al actualizar la tarea"));
    }
  }

  @override
  Future<void> close() {
    _todoListSubscription.cancel();
    _todoItemsSubscription.cancel();
    return super.close();
  }
}
