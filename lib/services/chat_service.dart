import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get uid => _auth.currentUser!.uid;

  /// ================= Conversations =================
  Stream<QuerySnapshot<Map<String, dynamic>>> conversations() {
    return _firestore
        .collection('conversations')
        .where('members', arrayContains: uid)
        .orderBy('lastMessageAt', descending: true)
        .snapshots();
  }

  /// ================= Messages =================
  Stream<QuerySnapshot<Map<String, dynamic>>> messages(String convoId) {
    return _firestore
        .collection('conversations')
        .doc(convoId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  /// ================= Send Message =================
  Future<void> sendMessage({
    required String conversationId,
    required String text,
  }) async {
    final ref = _firestore.collection('conversations').doc(conversationId);

    await ref.collection('messages').add({
      'senderId': uid,
      'text': text,
      'createdAt': FieldValue.serverTimestamp(),
    });

    await ref.update({
      'lastMessage': text,
      'lastMessageAt': FieldValue.serverTimestamp(),
    });
  }

  /// ================= Create Conversation =================
  Future<String> createConversation(String otherUid) async {
    final myUid = uid;

    // 🔒 منع تكرار المحادثة
    final existing = await _firestore
        .collection('conversations')
        .where('members', arrayContains: myUid)
        .get();

    for (final doc in existing.docs) {
      final members = List<String>.from(doc['members']);
      if (members.contains(otherUid)) {
        return doc.id;
      }
    }

    final doc = _firestore.collection('conversations').doc();

    await doc.set({
      'members': [myUid, otherUid],
      'lastMessage': '',
      'lastMessageAt': FieldValue.serverTimestamp(),
      'createdAt': FieldValue.serverTimestamp(),
    });

    return doc.id;
  }
}
