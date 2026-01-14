import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loopx/widgets/app_bottom_nav.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LessonPage extends StatefulWidget {
  final String courseId;
  final int lessonOrder;

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

  YoutubePlayerController? _controller;

  List<QueryDocumentSnapshot<Map<String, dynamic>>> lessons = [];
  Map<String, dynamic>? lessonData;

  @override
  void initState() {
    super.initState();
    _loadLesson();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  // ================= LOAD LESSON =================
  Future<void> _loadLesson() async {
    try {
      final snap = await FirebaseFirestore.instance
          .collection('courses')
          .doc(widget.courseId)
          .collection('lessons')
          .orderBy('order')
          .get();

      if (snap.docs.isEmpty) {
        hasError = true;
        return;
      }

      lessons = snap.docs;

      QueryDocumentSnapshot<Map<String, dynamic>>? found;

      for (final doc in lessons) {
        final order = doc.data()['order'];
        if (order is int && order == widget.lessonOrder) {
          found = doc;
          break;
        }
      }

      found ??= lessons.first;
      lessonData = found.data();

      final videoUrl = lessonData!['videoUrl']?.toString();
      final videoId = YoutubePlayer.convertUrlToId(videoUrl ?? '');

      if (videoId == null) {
        hasError = true;
        return;
      }

      _controller =
          YoutubePlayerController(
            initialVideoId: videoId,
            flags: const YoutubePlayerFlags(
              autoPlay: false,
              enableCaption: true,
            ),
          )..addListener(() {
            if (_controller!.value.playerState == PlayerState.ended) {
              setState(() => videoCompleted = true);
            }
          });
    } catch (_) {
      hasError = true;
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (hasError || lessonData == null || _controller == null) {
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
            // ================= VIDEO PLAYER =================
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: YoutubePlayer(
                controller: _controller!,
                showVideoProgressIndicator: true,
                progressIndicatorColor: Colors.deepPurple,
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

  // ================= NEXT LOGIC =================
  Future<void> _goNext(BuildContext context, bool isLastLesson) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final usersRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid);

    // ▶️ NEXT LESSON
    if (!isLastLesson) {
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
      return;
    }

    // ================= COURSE FINISHED =================
    final currentCourseSnap = await FirebaseFirestore.instance
        .collection('courses')
        .doc(widget.courseId)
        .get();

    final int currentOrder = currentCourseSnap.data()?['order'] ?? 0;

    final nextCourseSnap = await FirebaseFirestore.instance
        .collection('courses')
        .where('order', isEqualTo: currentOrder + 1)
        .limit(1)
        .get();

    if (nextCourseSnap.docs.isEmpty) {
      await usersRef.update({'progress.courseCompleted': true});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('🎉 You finished all courses!')),
      );

      Navigator.pop(context);
      return;
    }

    final nextCourseId = nextCourseSnap.docs.first.id;

    await usersRef.update({
      'progress.courseId': nextCourseId,
      'progress.lessonOrder': 1,
      'progress.courseCompleted': false,
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => LessonPage(courseId: nextCourseId, lessonOrder: 1),
      ),
    );
  }
}
