import 'package:cloud_firestore/cloud_firestore.dart';

final db = FirebaseFirestore.instance;

Future<String> createTaskInFireStore(Map<String, dynamic> task) async {
  try {
    DocumentReference docRef = await db.collection('tasks').add(task);
    return docRef.id;
  } catch (e) {
    throw Exception("Unable to store tasks , error : $e");
  }
}
