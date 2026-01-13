import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loopx/widgets/app_bottom_nav.dart';

class LessonPage extends StatefulWidget {
  final String courseId; // مثال: "Html"
  final int lessonOrder; // مثال: 1

  const LessonPage({
    super.key,
    required this.courseId,
    required this.lessonOrder,
  });

  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  bool videoCompleted = false;
  bool isLoading = true;
  bool hasError = false;

  List<QueryDocumentSnapshot<Map<String, dynamic>>> lessons = [];
  Map<String, dynamic>? lessonData;

  @override
  void initState() {
    super.initState();
    _loadLesson();
  }

  // ================= LOAD LESSON =================
  Future<void> _loadLesson() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('courses')
          .doc(widget.courseId) // ⚠️ نفس الاسم بالضبط (Html)
          .collection('lessons')
          .orderBy('order')
          .get();

      if (snapshot.docs.isEmpty) {
        hasError = true;
        return;
      }

      lessons = snapshot.docs;

      QueryDocumentSnapshot<Map<String, dynamic>>? foundLesson;

      for (final doc in lessons) {
        final data = doc.data();
        final order = data['order'];

        if (order is int && order == widget.lessonOrder) {
          foundLesson = doc;
          break;
        }
      }

      if (foundLesson == null) {
        hasError = true;
        return;
      }

      lessonData = foundLesson.data();
    } catch (e) {
      hasError = true;
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (hasError || lessonData == null) {
      return const Scaffold(body: Center(child: Text('Failed to load lesson')));
    }

    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final title = lessonData!['title']?.toString() ?? 'Lesson';
    final summary = lessonData!['summary']?.toString() ?? '';

    final bool isLastLesson = widget.lessonOrder >= lessons.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================= VIDEO =================
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: BoxDecoration(
                  color: colors.surfaceVariant,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(
                      Icons.play_circle_fill,
                      size: 64,
                      color: Colors.deepPurple,
                    ),
                    Positioned(
                      bottom: 12,
                      right: 12,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() => videoCompleted = true);
                        },
                        child: const Text('Mark video as watched'),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            Text(
              title,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              summary,
              style: textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
                height: 1.6,
              ),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: videoCompleted
                      ? Colors.deepPurple
                      : colors.surfaceVariant,
                  foregroundColor: videoCompleted
                      ? Colors.white
                      : colors.onSurfaceVariant,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                onPressed: videoCompleted
                    ? () => _goNext(context, isLastLesson)
                    : null,
                child: Text(
                  videoCompleted
                      ? (isLastLesson ? 'Finish Course' : 'Next Lesson')
                      : 'Watch the video to continue',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
    );
  }

  // ================= NEXT =================
  Future<void> _goNext(BuildContext context, bool isLast) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final usersRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid);

    if (!isLast) {
      await usersRef.update({'progress.lessonOrder': widget.lessonOrder + 1});

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => LessonPage(
            courseId: widget.courseId,
            lessonOrder: widget.lessonOrder + 1,
          ),
        ),
      );
    } else {
      await usersRef.update({'progress.courseCompleted': true});

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Course completed 🎉')));

      Navigator.pop(context);
    }
  }
}
