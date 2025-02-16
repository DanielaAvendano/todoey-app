import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class TodoItem extends Equatable {
  const TodoItem({
    required this.id,
    required this.description,
    this.translation = '',
    required this.createdAt,
    this.isCompleted = false,
  });

  final String id;
  final String description;
  final String translation;
  final DateTime createdAt;
  final bool isCompleted;

  factory TodoItem.fromMap(Map<String, dynamic> map, String id) {
    return TodoItem(
      id: id,
      description: map['description'],
      translation: map['translation'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      isCompleted: map['isCompleted'] ?? false,
    );
  }
  factory TodoItem.fromJson(Map<String, dynamic> json) {
    return TodoItem(
      id: json['id'],
      description: json['description'],
      translation: json['translation'] ?? '',
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'translation': translation,
      'createdAt': createdAt,
      'isCompleted': isCompleted,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'translation': translation,
      'createdAt': createdAt,
      'isCompleted': isCompleted,
    };
  }

  @override
  List<Object?> get props => [
        id,
        description,
        translation,
        createdAt,
        isCompleted,
      ];
}
