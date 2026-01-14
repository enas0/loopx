import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_profile.dart';

class ProfileService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  String get _uid => _auth.currentUser!.uid;

  Future<UserProfile?> fetchProfile() async {
    final doc = await _firestore.collection('users').doc(_uid).get();

    if (!doc.exists) return null;

    return UserProfile.fromMap(doc.data()!);
  }

  Future<void> saveProfile(UserProfile profile) async {
    await _firestore
        .collection('users')
        .doc(_uid)
        .set(profile.toMap(), SetOptions(merge: true));
  }
}
