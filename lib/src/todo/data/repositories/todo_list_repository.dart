import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_doey/src/todo/domain/entities/todo_item.dart';
import 'package:to_doey/src/todo/domain/entities/todo_list.dart';

class TodoListRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static const todoListsCollection = 'todoLists';
  static const itemsSubcollection = 'items';

  Future<String> createTodoList(TodoList todoList) async {
    final docRef = await firestore.collection(todoListsCollection).add({
      'title': todoList.title,
      'userId': todoList.userId,
      'createdAt': todoList.createdAt,
    });

    return docRef.id;
  }

  Future<List<TodoList>> getTodoLists() async {
    final querySnapshot = await firestore.collection('todoLists').get();

    return await Future.wait(querySnapshot.docs.map((doc) async {
      final itemsSnapshot = await firestore
          .collection('todoLists')
          .doc(doc.id)
          .collection('items')
          .get();

      final items = itemsSnapshot.docs.map((itemDoc) {
        print("Item encontrado en ${doc.id}: ${itemDoc.data()}"); // Debug
        return TodoItem.fromMap(itemDoc.data(), itemDoc.id);
      }).toList();

      final todoList =
          TodoList.fromMap(doc.data(), doc.id).copyWith(items: items);
      print(
          "Lista: ${todoList.title} tiene ${todoList.items.length} items"); // Debug
      return todoList;
    }).toList());
  }

  Future<void> addTodoItem(String listId, TodoItem todoItem) async {
    await firestore
        .collection(todoListsCollection)
        .doc(listId)
        .collection(itemsSubcollection)
        .add(todoItem.toMap());
  }
}
