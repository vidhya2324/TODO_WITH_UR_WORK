import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todolist/addtodo_create.dart';
import 'package:todolist/auth/login_page.dart';
import 'package:todolist/auth/profile_page.dart';
import 'package:todolist/delete_todo_button.dart';

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "TODO With Your Work",
            style: TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          Padding(padding: EdgeInsets.only(right: 12),
          child: ProfilePopupMenu(),)



        ],
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(uid)
            .collection("todos")
            .orderBy("createdAt", descending: true)
            .snapshots(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty)
            return Center(child: Text("No todos added yet"));

          final allDocs = snapshot.data!.docs;

          //separate the completed todos and pending todos

          final pending = allDocs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return data['completed'] == false;
          }).toList();

          final completed = allDocs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return data['completed'] == true;
          }).toList();

          return ListView(
            children: [
              if (pending.isNotEmpty)
                const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    "PENDING",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),

              ...pending.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return Card(
                  child: ListTile(
                    leading: IconButton(
                      onPressed: () {
                        doc.reference.update({"completed": true});
                      },
                      icon: Icon(Icons.radio_button_unchecked),
                    ),

                    title: Text(
                      data["title"] ?? "",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(data['description'] ?? ""),
                    trailing: DeleteTodoButton(docRef: doc.reference),
                  ),
                );
              }),

              //completed section
              if (completed.isNotEmpty)
                const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    "COMPLETED",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.greenAccent,
                    ),
                  ),
                ),

              ...completed.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return Card(
                  color: Colors.grey.shade900,
                  child: ListTile(
                    leading: IconButton(
                      icon: const Icon(Icons.check_circle, color: Colors.green),
                      onPressed: () {
                        doc.reference.update({"completed": false});
                      },
                    ),

                    title: Text(
                      data["title"] ?? "",
                      style: const TextStyle(
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    subtitle: Text(data['description'] ?? ""),
                    trailing: DeleteTodoButton(docRef: doc.reference),
                  ),
                );
              }),
            ],
          );

          // final docs = snapshot.data!.docs;
          // return ListView.builder(
          //   itemCount: docs.length,
          //   itemBuilder: (context, i) {
          //     final data = docs[i].data() as Map<String, dynamic>;
          //     return Card(
          //       margin: const EdgeInsets.symmetric(horizontal: 12,vertical: 6),
          //       child: ListTile(
          //         title: Text(data["title"]??'Add Title',style: const TextStyle(fontWeight: FontWeight.bold),),
          //         subtitle: Text(data["description"]??'Add Description'),
          //       ),
          //     );
          //   },
          // );
        },
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigatorAddTodo,
        label: Text("Add ToDo"),
        icon: Icon(Icons.add),
      ),
    );
  }

  void navigatorAddTodo() {
    final route = MaterialPageRoute(builder: (context) => Addtodo());
    Navigator.push(context, route);
  }
}
