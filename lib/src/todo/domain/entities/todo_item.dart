import 'package:equatable/equatable.dart';

class TodoItem extends Equatable {
  final String id;
  final String description;
  final String translation;
  final bool isCompleted;

  const TodoItem({
    required this.id,
    required this.description,
    this.translation = '',
    this.isCompleted = false,
  });

  factory TodoItem.fromMap(Map<String, dynamic> map, String id) {
    return TodoItem(
      id: id,
      description: map['description'],
      translation: map['translation'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'translation': translation,
      'isCompleted': isCompleted,
    };
  }

  @override
  List<Object?> get props => [
        id,
        description,
        translation,
        isCompleted,
      ];
}
