// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_notes/screens/add_note.dart';
import 'package:firebase_notes/services/firebase_services.dart';
import 'package:flutter/material.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NOTES'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigationToAddPage,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: firebaseFirestore.collection("Notes").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                // variable
                final fetch = snapshot.data!.docs[index];
                final Map myData = {
                  'title': snapshot.data!.docs[index]['title'],
                  'detail': snapshot.data!.docs[index]['detail'].toString(),
                };
                // final myData =
                //     snapshot.data!.docs[index] as Map<String, dynamic>;
                return Dismissible(
                  key: UniqueKey(),
                  background: Container(color: Colors.red),
                  onDismissed: (d) {
                    FirebaseServices.deleteData(snapshot.data!.docs[index].id);
                    showSuccess('Successfuly Delete');
                  },
                  child: Card(
                    child: ExpansionTile(
                      title: Text(
                        fetch['title'],
                        style: const TextStyle(
                          fontSize: 20,
                          letterSpacing: 2.0,
                        ),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18.0, vertical: 5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                fetch['detail'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  wordSpacing: 2.0,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  navigateToEditPage(
                                      myData, snapshot.data!.docs[index].id);
                                  // print(myData.toString());
                                },
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.cyan,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  // (((((((LONEWOLF((((((((FUNCTIONS))))))))SAQIB AHMED)))))))

  // addsuccess msg
  void showSuccess(String msg) {
    final SnackBar snackBar = SnackBar(
      content: Text(msg),
      backgroundColor: Colors.green.shade400,
      behavior: SnackBarBehavior.floating,
      clipBehavior: Clip.antiAlias,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // NAVIGATION FUNCTION

  // nav to addpage
  navigationToAddPage() {
    // ignore: prefer_const_constructors
    Navigator.push(context, MaterialPageRoute(builder: (context) => AddNote()));
  }

  // nav to editpage
  void navigateToEditPage(Map myData, String id) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddNote(todo: myData, docId: id)));
  }
}
