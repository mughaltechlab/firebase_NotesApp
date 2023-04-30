// ignore_for_file: body_might_complete_normally_nullable, prefer_const_constructors_in_immutables

import 'package:firebase_notes/services/firebase_services.dart';
import 'package:flutter/material.dart';

class AddNote extends StatefulWidget {
  final Map? todo;
  final String? docId;
  const AddNote({
    super.key,
    this.todo,
    this.docId,
  });

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
// variables
  // initialize textfield controller
  final TextEditingController titleC = TextEditingController();
  final TextEditingController detailC = TextEditingController();
  // formkey
  final formKey = GlobalKey<FormState>();
  // for editing
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final detail = todo['detail'];
      titleC.text = title;
      detailC.text = detail;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'EDIT NOTE' : 'ADD NOTE'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'please enter your title';
                    }
                  },
                  controller: titleC,
                  decoration: InputDecoration(
                    label: Text(isEdit ? 'Update Title' : 'Enter Title'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'please enter your detail';
                    }
                  },
                  controller: detailC,
                  minLines: 1,
                  maxLines: 7,
                  decoration: InputDecoration(
                    label: Text(
                      isEdit ? 'Update Detail' : 'Enter Detail',
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      isEdit
                          ? FirebaseServices.updateData(
                              widget.docId.toString(),
                              titleC.text,
                              detailC.text,
                            )
                          : FirebaseServices.addData(titleC.text, detailC.text);
                      showSuccess(
                        isEdit ? 'Edit Successfully' : 'Add Successfuly',
                        isEdit ? Colors.blue.shade300 : Colors.green.shade400,
                      );
                      setState(() {
                        titleC.text = '';
                        detailC.text = '';
                      });
                    }
                  },
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(
                        const Size(double.infinity, 40)),
                  ),
                  child: Text(
                    isEdit ? 'UPDATE' : 'ADD',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // (((((((LONEWOLF((((((((FUNCTIONS))))))))SAQIB AHMED)))))))

  // addsuccess msg
  void showSuccess(String msg, Color color) {
    final SnackBar snackBar = SnackBar(
      content: Text(msg),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      clipBehavior: Clip.antiAlias,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
