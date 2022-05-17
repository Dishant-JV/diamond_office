import 'package:diamond_office/Diamond/owner/real_time_database/todo_mode.dart';
import 'package:get/get.dart';

import 'firestoredb.dart';

class TodoController extends GetxController {
  Rx<List<TodoModel>> todoList = Rx<List<TodoModel>>([]);

  List<TodoModel> get todos => todoList.value;

  @override
  void onReady() {
    todoList.bindStream(FirestoreDb.todoStream());
  }
}
