part of 'todo_list_bloc.dart';

abstract class TodoListEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadTodos extends TodoListEvent {}

class CreateTodoListEvent extends TodoListEvent {
  final TodoList todoList;

  CreateTodoListEvent(this.todoList);

  @override
  List<Object> get props => [todoList];
}

class AddTodoItemEvent extends TodoListEvent {
  final String listId;
  final TodoItem todoItem;

  AddTodoItemEvent(this.listId, this.todoItem);

  @override
  List<Object> get props => [listId, todoItem];
}

class TodoListsUpdated extends TodoListEvent {
  final List<TodoList> todoLists;

  TodoListsUpdated(this.todoLists);

  @override
  List<Object> get props => [todoLists];
}
