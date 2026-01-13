import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:loopx/widgets/app_bottom_nav.dart';
import 'lesson_page.dart';

class CourseOverviewPage extends StatelessWidget {
  final String courseId;

  const CourseOverviewPage({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(body: Center(child: Text('User not logged in')));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Course Overview',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('courses')
            .doc(courseId)
            .get(),
        builder: (context, courseSnapshot) {
          if (!courseSnapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final courseData =
              courseSnapshot.data!.data() as Map<String, dynamic>;

          final String title = courseData['title'];
          final String description = courseData['description'];
          final List outcomes = courseData['outcomes'] ?? [];
          final List resources = courseData['resources'] ?? [];

          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get(),
            builder: (context, userSnapshot) {
              if (!userSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final userData =
                  userSnapshot.data!.data() as Map<String, dynamic>?;

              final progress = userData?['progress'] as Map<String, dynamic>?;

              final int lessonOrder = progress?['lessonOrder'] ?? 1;

              return _Content(
                title: title,
                description: description,
                outcomes: outcomes,
                resources: resources,
                courseId: courseId,
                lessonOrder: lessonOrder,
              );
            },
          );
        },
      ),

      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                                  CONTENT                                   */
/* -------------------------------------------------------------------------- */

class _Content extends StatelessWidget {
  final String title;
  final String description;
  final List outcomes;
  final List resources;
  final String courseId;
  final int lessonOrder;

  const _Content({
    required this.title,
    required this.description,
    required this.outcomes,
    required this.resources,
    required this.courseId,
    required this.lessonOrder,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ================= HERO =================
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.deepPurple, Colors.deepPurpleAccent],
              ),
              borderRadius: BorderRadius.circular(32),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$title Course',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          const SizedBox(height: 36),

          // ================= OUTCOMES =================
          Text(
            'What you will learn',
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          ...outcomes.map((o) => _bullet(o.toString())),

          const SizedBox(height: 36),

          // ================= RESOURCES =================
          Text(
            'Resources',
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          ...resources.map(
            (res) => Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  const Icon(Icons.link, color: Colors.deepPurple),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      res['title'],
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.open_in_new,
                    color: colors.onSurfaceVariant,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 48),

          // ================= START =================
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LessonPage(
                      courseId: courseId,
                      lessonOrder: lessonOrder,
                    ),
                  ),
                );
              },
              child: const Text(
                'Start Learning',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Icon(Icons.check_circle, size: 18, color: Colors.deepPurple),
          SizedBox(width: 12),
        ],
      ),
    );
  }
}
