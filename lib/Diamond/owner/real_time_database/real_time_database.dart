// import 'package:diamond_office/Diamond/owner/real_time_database/todo_controller.dart';
// import 'package:diamond_office/Diamond/owner/real_time_database/todo_mode.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
//
// import 'firestoredb.dart';
//
// class RealTiMeDataBase extends StatefulWidget {
//   const RealTiMeDataBase({Key? key}) : super(key: key);
//
//   @override
//   _RealTiMeDataBaseState createState() => _RealTiMeDataBaseState();
// }
//
// class _RealTiMeDataBaseState extends State<RealTiMeDataBase> {
//   TodoController todoController=TodoController();
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     print(todoController.todos.length);
//   }
//   final contentTextEditorController=TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           SizedBox(height: MediaQuery.of(context).padding.top+20,),
//           TextField(
//             controller: contentTextEditorController,
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               final todoModel = TodoModel(
//                 content: contentTextEditorController.text.trim(),
//                 isDone: false,
//               );
//               await FirestoreDb.addTodo(todoModel);
//               contentTextEditorController.clear();
//             },
//             child: const Text(
//               "Add Todo",
//             ),
//           ),
//           GetX<TodoController>(
//             init: Get.put<TodoController>(TodoController()),
//             builder: (TodoController todoController) {
//               return Expanded(
//                 child: ListView.builder(
//                   itemCount: todoController.todos.length,
//                   itemBuilder: (BuildContext context, int index) {
//                     print(todoController.todos[index].content);
//                     final _todoModel = todoController.todos[index];
//                     return Container(
//                       margin: const EdgeInsets.symmetric(
//                         horizontal: 4,
//                         vertical: 4,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.black26,
//                         borderRadius: BorderRadius.circular(4),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Row(
//                           children: [
//                             Expanded(
//                               child: Text(
//                                 _todoModel.content,
//                                 style: TextStyle(
//                                   fontSize: Get.textTheme.headline6!.fontSize,
//                                   decoration: _todoModel.isDone
//                                       ? TextDecoration.lineThrough
//                                       : TextDecoration.none,
//                                 ),
//                               ),
//                             ),
//                             Checkbox(
//                               value: _todoModel.isDone,
//                               onChanged: (status) {
//                                 FirestoreDb.updateStatus(
//                                   status!,
//                                   _todoModel.documentId,
//                                 );
//                               },
//                             ),
//                             IconButton(
//                               onPressed: () {
//                                 FirestoreDb.deleteTodo(
//                                     _todoModel.documentId!);
//                               },
//                               icon: const Icon(
//                                 Icons.delete,
//                                 color: Colors.redAccent,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               );
//             },
//           )
//
//         ],
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TestWidget extends StatefulWidget {
  const TestWidget({Key? key}) : super(key: key);

  @override
  _TestWidgetState createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  final contentTextEditorController = TextEditingController();
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('Owner').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(
            controller: contentTextEditorController,
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () async {
              setData(contentTextEditorController.text);
            },
            child: const Text(
              "Add Todo",
            ),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: _usersStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }
                List productName = [];
                snapshot.data?.docs.map((DocumentSnapshot document) {
                  Map a = document.data() as Map<String, dynamic>;
                  productName.add(a);
                }).toList();
                print(productName);
                print("data");
                // print(data);
                return ListView.builder(
                    itemCount: productName.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Text(productName[index]['name']);
                    });

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LinearProgressIndicator();
                }
              }),
        ],
      ),
    );
  }

  void setData(String text) async {
    await FirebaseFirestore.instance.collection('Real').add(
        {'text': text}).whenComplete(() => contentTextEditorController.clear());
  }
}
