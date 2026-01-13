import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'home_page.dart';
import 'select_path_page.dart';

class EntryPage extends StatelessWidget {
  const EntryPage({super.key});

  Future<String?> _loadTrack() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return null;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (!doc.exists) return null;

    return doc.data()?['track'];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _loadTrack(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final track = snapshot.data;

        if (track == null) {
          return const SelectPathPage();
        }

        return const HomePage();
      },
    );
  }
}
