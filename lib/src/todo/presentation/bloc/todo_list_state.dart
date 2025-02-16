part of 'todo_list_bloc.dart';

abstract class TodoListState extends Equatable {
  @override
  List<Object> get props => [];
}

class TodoListInitial extends TodoListState {}

class TodoListLoading extends TodoListState {}

class TodoListCreated extends TodoListState {}

class TodoListsLoaded extends TodoListState {
  final List<TodoList> todoLists;

  TodoListsLoaded(this.todoLists);

  @override
  List<Object> get props => [todoLists];
}

class TodoOperationSuccess extends TodoListState {
  final String message;

  TodoOperationSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class TodoListError extends TodoListState {
  final String message;

  TodoListError(this.message);

  @override
  List<Object> get props => [message];
}
