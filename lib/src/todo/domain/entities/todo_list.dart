import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:to_doey/src/todo/domain/entities/todo_item.dart';

class TodoList extends Equatable {
  const TodoList({
    required this.id,
    required this.title,
    required this.userId,
    required this.createdAt,
    this.items = const [],
  });

  final String id;
  final String title;
  final String userId;
  final DateTime createdAt;
  final List<TodoItem> items;

  TodoList copyWith({
    String? id,
    String? title,
    String? userId,
    DateTime? createdAt,
    List<TodoItem>? items,
  }) {
    return TodoList(
      id: id ?? this.id,
      title: title ?? this.title,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      items: items ?? this.items,
    );
  }

  factory TodoList.fromMap(Map<String, dynamic> data, String id) {
    return TodoList(
      id: id,
      title: data['title'],
      userId: data['userId'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      items: (data['items'] as List<dynamic>?)
              ?.map((item) => TodoItem.fromMap(item, id))
              .toList() ??
          [],
    );
  }

  @override
  List<Object> get props => [id, title, userId, createdAt, items];
}
