// ignore_for_file: avoid_print, body_might_complete_normally_catch_error

import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

class FirebaseServices {
  // function for creating notes in firestore
  static Future<void> addData(String title, String detail) async {
    Map<String, dynamic> data = {
      'title': title,
      'detail': detail,
    };
    await firebaseFirestore
        .collection("Notes")
        .add(data)
        .whenComplete(() => print('add success'))
        .catchError((e) {
      print(e.toString());
    });
  } //creating notes complete

  // Delete Function
  static Future<void> deleteData(String id) async {
    await firebaseFirestore.collection("Notes").doc(id).delete();
  }
  //......... delete cmplt...........

  // UPDATE FUNCTION
  static Future<void> updateData(String id, String title, String detail) async {
    await firebaseFirestore.collection("Notes").doc(id).update({
      'title': title,
      'detail': detail,
    });
  }

  // (((((((LONEWOLF((((((((FUNCTIONS))))))))SAQIB AHMED)))))))
}
