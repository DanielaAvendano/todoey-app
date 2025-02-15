import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:to_doey/src/todo/data/repositories/todo_list_repository.dart';
import 'package:to_doey/src/todo/domain/entities/todo_item.dart';
import 'package:to_doey/src/todo/domain/entities/todo_list.dart';

part 'todo_list_event.dart';
part 'todo_list_state.dart';

class TodoListBloc extends Bloc<TodoListEvent, TodoListState> {
  final TodoListRepository repository;

  TodoListBloc(this.repository) : super(TodoListInitial()) {
    on<CreateTodoListEvent>(_onCreateTodoList);
    on<FetchTodoListsEvent>(_onFetchTodoLists);
    on<AddTodoItemEvent>(_onAddTodoItem);
  }

  Future<void> _onCreateTodoList(
      CreateTodoListEvent event, Emitter<TodoListState> emit) async {
    emit(TodoListLoading());
    try {
      await repository.createTodoList(event.todoList);
      final updatedLists = await repository.getTodoLists(); // Recargar listas
      emit(TodoListsLoaded(updatedLists));
    } catch (e) {
      emit(TodoListError("Error al crear la lista de tareas"));
    }
  }

  Future<void> _onFetchTodoLists(
      FetchTodoListsEvent event, Emitter<TodoListState> emit) async {
    emit(TodoListLoading());
    try {
      final todoLists = await repository.getTodoLists();
      emit(TodoListsLoaded(todoLists));
    } catch (e) {
      emit(TodoListError("Error al obtener las listas de tareas"));
    }
  }

  Future<void> _onAddTodoItem(
      AddTodoItemEvent event, Emitter<TodoListState> emit) async {
    try {
      await repository.addTodoItem(event.listId, event.todoItem);

      // Volver a obtener todas las listas con sus items actualizados
      final updatedLists = await repository.getTodoLists();
      emit(TodoListsLoaded(updatedLists));
    } catch (e) {
      emit(TodoListError("Error al agregar la tarea"));
    }
  }
}
