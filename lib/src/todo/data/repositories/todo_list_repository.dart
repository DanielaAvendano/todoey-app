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

  //get all the todo lists
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

        return TodoList(
          id: doc.id,
          title: data['title'],
          userId: data['userId'],
          createdAt: (data['createdAt'] as Timestamp).toDate(),
        );
      }).toList();
    });
  }

  //get all the todo lists items
  Stream<List<TodoItem>> getTodosItems(String todoListId) {
    return _todosCollection
        .doc(todoListId)
        .collection('items')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        return TodoItem(
          id: doc.id,
          description: data['description'] ?? '',
          translation: data['translation'] ?? '',
          createdAt: (data['createdAt'] as Timestamp).toDate(),
          isCompleted: data['isCompleted'] ?? false,
        );
      }).toList();
    });
  }

  Future<String> createTodoList(TodoList todoList) async {
    final docRef = await firestore.collection(todoListsCollection).add({
      'title': todoList.title,
      'userId': todoList.userId,
      'createdAt': todoList.createdAt,
    });
    return docRef.id;
  }

  Future<TodoItem> addTodoItem(String listId, TodoItem todoItem) async {
    final docRef = await firestore
        .collection(todoListsCollection)
        .doc(listId)
        .collection(itemsSubcollection)
        .add(todoItem.toJson());

    final newTodoItem = todoItem.copyWith(id: docRef.id);
    await docRef.update({'id': docRef.id});
    return newTodoItem;
  }

  Future<void> updateTodoItem(String listId, TodoItem todoItem) async {
    final docRef = firestore
        .collection(todoListsCollection)
        .doc(listId)
        .collection(itemsSubcollection)
        .doc(todoItem.id);

    await docRef.update(todoItem.toJson());
  }

  Future<void> deleteTodoItem(String listId, TodoItem todoItem) async {
    final docRef = firestore
        .collection(todoListsCollection)
        .doc(listId)
        .collection(itemsSubcollection)
        .doc(todoItem.id);

    await docRef.delete();
  }
}
