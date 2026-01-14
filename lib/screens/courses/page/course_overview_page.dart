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

      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: FirebaseFirestore.instance
            .collection('courses')
            .doc(courseId)
            .get(),
        builder: (context, courseSnapshot) {
          if (courseSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!courseSnapshot.hasData || !courseSnapshot.data!.exists) {
            return const Center(child: Text('Course not found'));
          }

          final data = courseSnapshot.data!.data()!;

          final String title = data['title']?.toString() ?? courseId;
          final String track = data['track']?.toString() ?? '';
          final String category = data['category']?.toString() ?? '';
          final String description = data['description']?.toString() ?? '';

          final List outcomes = (data['outcomes'] is List)
              ? data['outcomes']
              : [];

          final List resources = (data['resources'] is List)
              ? data['resources']
              : [];

          return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get(),
            builder: (context, userSnapshot) {
              int lessonOrder = 1;

              if (userSnapshot.hasData && userSnapshot.data!.exists) {
                lessonOrder =
                    userSnapshot.data!.data()?['progress']?['lessonOrder'] ?? 1;
              }

              return _Content(
                title: title,
                track: track,
                category: category,
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

/*                                  CONTENT                                   */

class _Content extends StatelessWidget {
  final String title;
  final String track;
  final String category;
  final String description;
  final List outcomes;
  final List resources;
  final String courseId;
  final int lessonOrder;

  const _Content({
    required this.title,
    required this.track,
    required this.category,
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
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                if (track.isNotEmpty)
                  Text(
                    'Track: $track',
                    style: const TextStyle(color: Colors.white70),
                  ),
                if (category.isNotEmpty)
                  Text(
                    'Category: $category',
                    style: const TextStyle(color: Colors.white70),
                  ),
                if (description.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    description,
                    style: const TextStyle(color: Colors.white70, height: 1.5),
                  ),
                ],
              ],
            ),
          ),

          // ================= OUTCOMES =================
          if (outcomes.isNotEmpty) ...[
            const SizedBox(height: 40),
            Text(
              'What you will learn',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...outcomes.map(
              (o) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: 18,
                      color: Colors.deepPurple,
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text(o.toString())),
                  ],
                ),
              ),
            ),
          ],

          // ================= RESOURCES =================
          if (resources.isNotEmpty) ...[
            const SizedBox(height: 40),
            Text(
              'Learning Resources',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...resources.map((res) {
              final title = res['title']?.toString() ?? 'Resource';
              final url = res['url']?.toString() ?? '';

              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: colors.outlineVariant),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.link, color: Colors.deepPurple),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        title,
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.open_in_new,
                      size: 18,
                      color: colors.onSurfaceVariant,
                    ),
                  ],
                ),
              );
            }),
          ],

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
}
