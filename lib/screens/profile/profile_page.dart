import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../widgets/app_bottom_nav.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  bool _isEditing = false;
  bool _isLoading = true;

  final _nameCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();
  final _educationCtrl = TextEditingController();
  final _experienceCtrl = TextEditingController();
  final _projectsCtrl = TextEditingController();
  final _skillsCtrl = TextEditingController();

  String get _uid => _auth.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  /// 🔹 Load profile from Firestore
  Future<void> _loadProfile() async {
    final doc = await _firestore
        .collection('users')
        .doc(_uid)
        .collection('profile')
        .doc('profileid')
        .get();

    if (doc.exists) {
      final data = doc.data()!;
      _nameCtrl.text = data['name'] ?? '';
      _bioCtrl.text = data['bio'] ?? '';
      _educationCtrl.text = data['education'] ?? '';
      _experienceCtrl.text = data['experience'] ?? '';
      _projectsCtrl.text = data['projects'] ?? '';
      _skillsCtrl.text = (data['skills'] as List?)?.join(', ') ?? '';
    }

    setState(() => _isLoading = false);
  }

  /// 🔹 Save profile to Firestore
  Future<void> _saveProfile() async {
    await _firestore
        .collection('users')
        .doc(_uid)
        .collection('profile')
        .doc('profileid')
        .set({
          'name': _nameCtrl.text.trim(),
          'bio': _bioCtrl.text.trim(),
          'education': _educationCtrl.text.trim(),
          'experience': _experienceCtrl.text.trim(),
          'projects': _projectsCtrl.text.trim(),
          'skills': _skillsCtrl.text
              .split(',')
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList(),
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

    setState(() => _isEditing = false);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: () async {
              if (_isEditing) {
                await _saveProfile();
              } else {
                setState(() => _isEditing = true);
              }
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Avatar
            CircleAvatar(
              radius: 48,
              backgroundColor: colors.primaryContainer,
              child: Icon(
                Icons.person,
                size: 48,
                color: colors.onPrimaryContainer,
              ),
            ),

            const SizedBox(height: 16),

            _card(
              context,
              title: 'Basic Info',
              child: Column(
                children: [
                  _field('Name', _nameCtrl),
                  _field('Bio', _bioCtrl, maxLines: 3),
                ],
              ),
            ),

            _card(
              context,
              title: 'Education',
              child: _field('Education', _educationCtrl, maxLines: 2),
            ),

            _card(
              context,
              title: 'Experience',
              child: _field('Experience', _experienceCtrl, maxLines: 3),
            ),

            _card(
              context,
              title: 'Projects',
              child: _field('Projects', _projectsCtrl, maxLines: 2),
            ),

            _card(
              context,
              title: 'Skills',
              child: _field('Skills (comma separated)', _skillsCtrl),
            ),
          ],
        ),
      ),

      bottomNavigationBar: const AppBottomNav(currentIndex: 4),
    );
  }

  /// ================= UI Helpers =================

  Widget _card(
    BuildContext context, {
    required String title,
    required Widget child,
  }) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        _isEditing
            ? TextField(controller: controller, maxLines: maxLines)
            : Text(controller.text.isEmpty ? '-' : controller.text),
        const SizedBox(height: 12),
      ],
    );
  }
}
