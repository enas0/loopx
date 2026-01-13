import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loopx/widgets/app_bottom_nav.dart';
import 'course_overview_page.dart';

class CourseMapPage extends StatefulWidget {
  const CourseMapPage({super.key});

  @override
  State<CourseMapPage> createState() => _CourseMapPageState();
}

class _CourseMapPageState extends State<CourseMapPage> {
  bool isLoading = true;
  bool hasError = false;

  List<QueryDocumentSnapshot<Map<String, dynamic>>> courses = [];
  int currentOrder = 1;

  @override
  void initState() {
    super.initState();
    _loadMap();
  }

  Future<void> _loadMap() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      String? currentCourseId;

      if (user != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        currentCourseId = userDoc.data()?['progress']?['courseId'];
      }

      final snap = await FirebaseFirestore.instance
          .collection('courses')
          .orderBy('order')
          .get();

      courses = snap.docs;

      if (courses.isEmpty) {
        throw Exception('No courses');
      }

      // ✅ الحل الصحيح: تحديد الكورس الحالي بدون firstWhere
      QueryDocumentSnapshot<Map<String, dynamic>>? currentCourse;

      for (final c in courses) {
        if (c.id == currentCourseId) {
          currentCourse = c;
          break;
        }
      }

      currentCourse ??= courses.first;

      currentOrder = currentCourse.data()['order'] ?? 1;
    } catch (e) {
      hasError = true;
    }

    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (hasError) {
      return const Scaffold(
        body: Center(child: Text('Failed to load learning path')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Learning Path',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 40),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          final data = course.data();

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
                        builder: (_) => CourseOverviewPage(courseId: course.id),
                      ),
                    );
                  }
                : null,
          );
        },
      ),

      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
    );
  }
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
