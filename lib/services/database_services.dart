import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fazr/models/user_model.dart';

final db = FirebaseFirestore.instance;

Future<String> createTaskInFireStore(Map<String, dynamic> task) async {
  try {
    DocumentReference docRef = await db.collection('tasks').add(task);
    return docRef.id;
  } catch (e) {
    throw Exception("Unable to store tasks, error: $e");
  }
}

Future<QuerySnapshot> fetchAllTasksFromFireStore() async {
  try {
    return await db.collection('tasks').get();
  } catch (e) {
    throw Exception("Error fetching tasks: $e");
  }
}

Future<void> updateTaskInFireStore(
  String taskId,
  Map<String, dynamic> task,
) async {
  try {
    await db.collection('tasks').doc(taskId).update(task);
  } catch (e) {
    throw Exception("Failed to update task: $e");
  }
}

Future<void> deleteTaskFromFireStore(String taskId) async {
  try {
    await db.collection('tasks').doc(taskId).delete();
  } catch (e) {
    throw Exception("Error deleting task: $e");
  }
}

Future<void> addCompletedTaskInFireStore(String taskId, DateTime date) async {
  try {
    await db.collection('completed_tasks').add({
      'taskId': taskId,
      'completionDate': Timestamp.fromDate(date),
    });
  } catch (e) {
    throw Exception("Failed to add completed task: $e");
  }
}

Future<QuerySnapshot> getCompletedTaskFromFireStore(
  String taskId,
  DateTime date,
) async {
  try {
    return await db
        .collection('completed_tasks')
        .where('taskId', isEqualTo: taskId)
        .where('completionDate', isEqualTo: Timestamp.fromDate(date))
        .get();
  } catch (e) {
    throw Exception("Failed to fetch completed task: $e");
  }
}

Future<void> deleteCompletedTaskFromFireStore(String docId) async {
  try {
    await db.collection('completed_tasks').doc(docId).delete();
  } catch (e) {
    throw Exception("Failed to delete completed task: $e");
  }
}

Future<void> deleteInstanceInFireStore(String taskId, DateTime date) async {
  try {
    final dateKey = date.toIso8601String().split('T')[0];
    await db.collection('tasks').doc(taskId).update({
      'deletedInstances': FieldValue.arrayUnion([dateKey]),
    });
  } catch (e) {
    throw Exception('Failed to delete task instance: $e');
  }
}

Future<QuerySnapshot> fetchCompletedTasksFromFireStore() async {
  try {
    return await db.collection('completed_tasks').get();
  } catch (e) {
    throw Exception("Error fetching completed tasks: $e");
  }
}

Future<void> createUserInFireStore(UserModel user) async {
  try {
    await db.collection('users').doc(user.id).set(user.toJson());
  } catch (e) {
    throw Exception("Failed to create user in Firestore: $e");
  }
}

Future<UserModel?> getUserFromFireStore(String uid) async {
  try {
    DocumentSnapshot doc = await db.collection('users').doc(uid).get();
    if (doc.exists) {
      return UserModel.fromJson(doc.data() as Map<String, dynamic>);
    }
    return null;
  } catch (error) {
    throw Exception("Failed to get user from firestore: $error");
  }
}
