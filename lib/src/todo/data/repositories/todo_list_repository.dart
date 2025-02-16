import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:to_doey/src/todo/domain/entities/todo_item.dart';
import 'package:to_doey/src/todo/domain/entities/todo_list.dart';

class TodoListRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  static const todoListsCollection = 'todoLists';
  static const itemsSubcollection = 'items';

  final CollectionReference _todosCollection =
      FirebaseFirestore.instance.collection(todoListsCollection);

  Stream<List<TodoList>> getTodos() {
    final user = auth.currentUser;
    if (user == null) {
      return Stream.value([]);
    }
    return _todosCollection
        .where('userId', isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        List<TodoItem> items = [];
        if (data.containsKey('items') && data['items'] is List) {
          items = (data['items'] as List).map((item) {
            return TodoItem.fromJson(item as Map<String, dynamic>);
          }).toList();
        }

        return TodoList(
          id: doc.id,
          title: data['title'],
          userId: data['userId'],
          createdAt: (data['createdAt'] as Timestamp).toDate(),
          items: items,
        );
      }).toList();
    });
  }

  Future<String> createTodoList(TodoList todoList) async {
    final docRef = await firestore.collection(todoListsCollection).add({
      'title': todoList.title,
      'userId': todoList.userId,
      'createdAt': todoList.createdAt,
      'items': [],
    });

    return docRef.id;
  }

  Future<void> addTodoItem(String listId, TodoItem todoItem) async {
    await firestore.collection(todoListsCollection).doc(listId).update({
      'items': FieldValue.arrayUnion([todoItem.toJson()])
    });
  }
}
