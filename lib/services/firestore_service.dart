import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Collection path: users/{userId}/tasks/{taskId}
  CollectionReference _tasksRef(String userId) {
    return _db.collection('users').doc(userId).collection('tasks');
  }

  // Add Task
  Future<void> addTask(TaskModel task) {
    return _tasksRef(task.userId).add(task.toMap());
  }

  // Update Task
  Future<void> updateTask(TaskModel task) {
    return _tasksRef(task.userId).doc(task.id).update(task.toMap());
  }

  // Delete Task
  Future<void> deleteTask(String userId, String taskId) {
    return _tasksRef(userId).doc(taskId).delete();
  }

  // Mark Complete
  Future<void> markComplete(String userId, String taskId, bool isComplete) {
    return _tasksRef(userId).doc(taskId).update({
      'status': isComplete ? 'completed' : 'pending',
    });
  }

  // Get Tasks Stream
  Stream<List<TaskModel>> getTasks(String userId) {
    return _tasksRef(userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return TaskModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }
}
