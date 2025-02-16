part of 'todo_list_bloc.dart';

abstract class TodoListEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadTodos extends TodoListEvent {}

class LoadTodosItems extends TodoListEvent {
  final String listId;

  LoadTodosItems(this.listId);
}

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

class TodoItemsUpdated extends TodoListEvent {
  final List<TodoItem> todoItems;

  TodoItemsUpdated(this.todoItems);

  @override
  List<Object> get props => [todoItems];
}

class UpdateTodoItem extends TodoListEvent {
  final String listId;
  final TodoItem todoItem;

  UpdateTodoItem(this.listId, this.todoItem);
}

class DeleteTodoItem extends TodoListEvent {
  final String listId;
  final TodoItem itemId;

  DeleteTodoItem(this.listId, this.itemId);
}
