import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:to_do_list/to_do_list.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key, required this.uid});

  final String uid;

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task'),
        centerTitle: true,
      ),
      body: Center (
        child: Column(
          children: [
            Container(
              width: 300.0,
              margin: EdgeInsets.fromLTRB(0, 30, 0, 8),
              child: TextField(
                controller: titleController,
                obscureText: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Title',
                ),
              ),
            ),
            Container(
              width: 300.0,
              margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
              child: TextField(
                controller: descController,
                obscureText: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Description',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                FirebaseFirestore.instance.collection(widget.uid)
                .add({
                  "title": titleController.text,
                  "desc": descController.text,
                })
                .then((value) {
                  print("Successfully added task.");
                  titleController.clear();
                  descController.clear();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ToDoListPage(uid: widget.uid)),
                  );
                })
                .catchError((error) {
                  print("Failed to add task.");
                  print(error);
                });
              },
              child: const Text('Add'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ToDoListPage(uid: widget.uid)),
                );
              },
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}
