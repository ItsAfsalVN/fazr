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

// REPLACE your old addCompletedTaskInFireStore with this
Future<void> addCompletedTaskInFireStore(String taskId, DateTime date) async {
  // 1. Normalize the date to midnight to keep it consistent.
  final normalizedDate = DateTime(date.year, date.month, date.day);
  
  // 2. Create a predictable, unique document ID.
  final docId = '${taskId}_${normalizedDate.toIso8601String().split('T')[0]}';

  try {
    await db.collection('completed_tasks').doc(docId).set({
      'taskId': taskId,
      'completedDate': Timestamp.fromDate(normalizedDate), 
    });
  } catch (e) {
    throw Exception("Failed to add completed task: $e");
  }
}

Future<void> deleteCompletedTaskFromFireStore(String taskId, DateTime date) async {
  final normalizedDate = DateTime(date.year, date.month, date.day);
  final docId = '${taskId}_${normalizedDate.toIso8601String().split('T')[0]}';

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

Future<void> updateUserInFirestore(
  String userId,
  Map<String, dynamic> data,
) async {
  try {
    await db.collection('users').doc(userId).update(data);
  } catch (e) {
    throw Exception("Failed to update user in Firestore: $e");
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

Future<QuerySnapshot> fetchHistoryFromFirestore() async {
  try {
    return await db.collection('task_history').get();
  } catch (e) {
    throw Exception("Error fetching task history: $e");
  }
}

Future<void> clearAllHistoryInFirestore() async {
  try {
    final collection = db.collection('task_history');
    final snapshot = await collection.get();

    final batch = db.batch();
    for (var doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  } catch (e) {
    throw Exception("Failed to clear task history: $e");
  }
}

Future<void> createHistoryRecordInFirestore({
  required String taskId,
  required String taskTitle,
  required DateTime instanceDate,
  required String status,
}) async {
  try {
    await db.collection('task_history').add({
      'taskId': taskId,
      'taskTitle': taskTitle,
      'instanceDate': Timestamp.fromDate(instanceDate),
      'status': status,
    });
  } catch (e) {
    throw Exception("Failed to create history record: $e");
  }
}

Future<bool> doesHistoryRecordExist(String taskId, DateTime date) async {
  final normalizedDate = DateTime(date.year, date.month, date.day);

  try {
    final snapshot = await db
        .collection('task_history')
        .where('taskId', isEqualTo: taskId)
        .where('instanceDate', isEqualTo: Timestamp.fromDate(normalizedDate))
        .limit(1)
        .get();

    return snapshot.docs.isNotEmpty;
  } catch (e) {
    print("Error checking if history record exists: $e");
    return false;
  }
}

Future<void> createOrUpdateHistoryRecord({
  required String taskId,
  required String taskTitle,
  required DateTime instanceDate,
  required String status,
}) async {
  final normalizedDate = DateTime(
    instanceDate.year,
    instanceDate.month,
    instanceDate.day,
  );
  final recordRef = db.collection('task_history');

  try {
    final snapshot = await recordRef
        .where('taskId', isEqualTo: taskId)
        .where('instanceDate', isEqualTo: Timestamp.fromDate(normalizedDate))
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final docId = snapshot.docs.first.id;
      await recordRef.doc(docId).update({'status': status});
      print('Updated history record for $taskId to "$status"');
    } else {
      await recordRef.add({
        'taskId': taskId,
        'taskTitle': taskTitle,
        'instanceDate': Timestamp.fromDate(normalizedDate),
        'status': status,
      });
      print('Created history record for $taskId with status "$status"');
    }
  } catch (e) {
    throw Exception("Failed to create or update history record: $e");
  }
}
