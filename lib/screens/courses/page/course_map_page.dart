import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'course_overview_page.dart';
import 'package:loopx/widgets/app_bottom_nav.dart';

class CourseMapPage extends StatelessWidget {
  const CourseMapPage({super.key});

  Future<_CourseMapData> _loadData() async {
    final user = FirebaseAuth.instance.currentUser;

    Map<String, dynamic>? progress;

    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      progress = userDoc.data()?['progress'];
    }

    final coursesSnap = await FirebaseFirestore.instance
        .collection('courses')
        .orderBy('order')
        .get();

    return _CourseMapData(progress: progress, courses: coursesSnap.docs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Learning Path',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: FutureBuilder<_CourseMapData>(
        future: _loadData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.hasError) {
            return const Center(child: Text('Failed to load courses'));
          }

          final data = snapshot.data!;
          final courses = data.courses;

          if (courses.isEmpty) {
            return const Center(child: Text('No courses found'));
          }

          // ===== تحديد الكورس الحالي =====
          final String currentCourseId =
              data.progress?['courseId']?.toString() ?? courses.first.id;

          final QueryDocumentSnapshot currentCourse = courses.firstWhere(
            (c) => c.id == currentCourseId,
            orElse: () => courses.first,
          );

          final int currentOrder =
              (currentCourse.data() as Map<String, dynamic>)['order'] ?? 1;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 40),
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final course = courses[index];
              final data = course.data() as Map<String, dynamic>;

              final int order = data['order'] ?? 0;

              final bool isCompleted = order < currentOrder;
              final bool isUnlocked = order == currentOrder;

              return _CourseMapItem(
                title: data['title']?.toString() ?? course.id,
                subtitle: data['track']?.toString() ?? '',
                isUnlocked: isUnlocked,
                isCompleted: isCompleted,
                showLine: index != courses.length - 1,
                onTap: isUnlocked
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                CourseOverviewPage(courseId: course.id),
                          ),
                        );
                      }
                    : null,
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
/*                                  MODEL                                     */
/* -------------------------------------------------------------------------- */

class _CourseMapData {
  final Map<String, dynamic>? progress;
  final List<QueryDocumentSnapshot> courses;

  _CourseMapData({required this.progress, required this.courses});
}

/* -------------------------------------------------------------------------- */
/*                                MAP ITEM                                    */
/* -------------------------------------------------------------------------- */

class _CourseMapItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isUnlocked;
  final bool isCompleted;
  final bool showLine;
  final VoidCallback? onTap;

  const _CourseMapItem({
    required this.title,
    required this.subtitle,
    required this.isUnlocked,
    required this.isCompleted,
    required this.showLine,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final Color nodeColor = isCompleted
        ? Colors.green
        : isUnlocked
        ? Colors.deepPurple
        : colors.outlineVariant;

    return Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(80),
          onTap: onTap,
          child: Column(
            children: [
              Container(
                width: 86,
                height: 86,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isUnlocked ? Colors.deepPurple : colors.surfaceVariant,
                ),
                child: Center(
                  child: Icon(
                    isCompleted
                        ? Icons.check
                        : isUnlocked
                        ? Icons.play_arrow
                        : Icons.lock,
                    color: isUnlocked ? Colors.white : colors.onSurfaceVariant,
                    size: 32,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (subtitle.isNotEmpty)
                Text(subtitle, style: textTheme.bodySmall),
            ],
          ),
        ),
        if (showLine)
          Container(
            height: 40,
            width: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: nodeColor.withOpacity(0.4),
            ),
          ),
      ],
    );
  }
}
