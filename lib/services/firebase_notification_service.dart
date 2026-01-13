import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/notification_model.dart';

class FirebaseNotificationService {
  FirebaseNotificationService._();
  static final FirebaseNotificationService instance =
      FirebaseNotificationService._();

  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String get _uid => _auth.currentUser!.uid;

  CollectionReference<Map<String, dynamic>> get _ref =>
      _db.collection('users').doc(_uid).collection('notifications');

  // READ (stream)
  Stream<List<AppNotification>> watchNotifications() {
    return _ref.orderBy('createdAt', descending: true).snapshots().map((
      snapshot,
    ) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return AppNotification(
          id: doc.id,
          title: data['title'],
          body: data['body'],
          taskId: data['taskId'],
          dateTime: DateTime.parse(data['dateTime']),
          read: data['read'] ?? false,
        );
      }).toList();
    });
  }

  // MARK AS READ
  Future<void> markAsRead(String id) async {
    await _ref.doc(id).update({'read': true});
  }

  // DELETE
  Future<void> delete(String id) async {
    await _ref.doc(id).delete();
  }
}
