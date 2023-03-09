import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:to_do_list/add_task.dart';
import 'package:to_do_list/main.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ToDoListPage extends StatefulWidget {
  const ToDoListPage({super.key, required this.uid});

  final String uid;

  @override
  State<ToDoListPage> createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
        ),
        title: Text('To Do List'),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection(widget.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          else if (snapshot.hasData || snapshot.data != null) {
            return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                QueryDocumentSnapshot<Object?>? documentSnapshot = snapshot.data!.docs[index];
                return Container(
                  margin: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 3,
                        offset: Offset(0, 2), // changes position of shadow
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Text(documentSnapshot["title"]),
                    subtitle: Text(documentSnapshot["desc"]),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        FirebaseFirestore.instance.collection(widget.uid)
                        .doc(documentSnapshot.id)
                        .delete()
                        .then((value){
                          print("Sucessfully deleted task");
                        })
                        .catchError((error){
                          print(error);
                        });
                      },
                    ),
                    onTap: () {
                      titleController.text = documentSnapshot["title"];
                      descController.text = documentSnapshot["desc"];
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            scrollable: true,
                            title: Text(
                              'Edit Task',
                              textAlign: TextAlign.center,
                            ),
                            content: Container(
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                                    child: TextField(
                                      controller: titleController,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                                    child: TextField(
                                      controller: descController,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, 'Cancel');
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  print(documentSnapshot.id);
                                  FirebaseFirestore.instance.collection(
                                      widget.uid)
                                      .doc(documentSnapshot.id)
                                      .update({
                                    "title": titleController.text,
                                    "desc": descController.text,
                                  })
                                      .then((value) {
                                    print("Successfully updated task.");
                                    titleController.clear();
                                    descController.clear();
                                  })
                                      .catchError((error) {
                                    print("Failed to updated task.");
                                    print(error);
                                  });
                                  Navigator.pop(context, 'Save');
                                },
                                child: const Text('Save'),
                              ),
                            ],
                          );
                        }
                      );
                    },
                  ),
                );
              }
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskPage(uid: widget.uid)),
          );
        },
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}
