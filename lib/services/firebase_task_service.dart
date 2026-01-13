import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/task_model.dart';

class FirebaseTaskService {
  FirebaseTaskService._();
  static final FirebaseTaskService instance = FirebaseTaskService._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _uid {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');
    return user.uid;
  }

  CollectionReference<Map<String, dynamic>> get _tasksRef {
    return _db.collection('users').doc(_uid).collection('tasks');
  }

  Future<void> addTask(Task task) async {
    await _tasksRef.doc(task.id).set({
      'title': task.title,
      'description': task.description,
      'dateTime': Timestamp.fromDate(task.dateTime),
      'repeat': task.repeat.name,
      'color': task.color.value,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateTask(Task task) async {
    await _tasksRef.doc(task.id).update({
      'title': task.title,
      'description': task.description,
      'dateTime': Timestamp.fromDate(task.dateTime),
      'repeat': task.repeat.name,
      'color': task.color.value,
    });
  }

  Future<void> deleteTask(String taskId) async {
    await _tasksRef.doc(taskId).delete();
  }

  Stream<List<Task>> watchTasks() {
    return _tasksRef.orderBy('dateTime').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Task(
          id: doc.id,
          title: data['title'],
          description: data['description'],
          dateTime: (data['dateTime'] as Timestamp).toDate(),
          repeat: RepeatType.values.firstWhere((e) => e.name == data['repeat']),
          color: Color(data['color']),
        );
      }).toList();
    });
  }
}
