import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QuizPage extends StatefulWidget {
  final String courseId;
  const QuizPage({super.key, required this.courseId});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int score = 0;

  // أسئلة Typed (مهم جدًا)
  final List<Map<String, Object>> questions = [
    {
      'q': 'HTML stands for?',
      'a': <String>['Hyper Text Markup Language', 'High Text Machine Language'],
      'correct': 0,
    },
  ];

  Future<void> _submitQuiz() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final bool passed = score >= 1; // شرط النجاح

    if (passed) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update(
        {
          'progress.quizPassed': true,
          'progress.courseId': 'css', // لاحقًا نحسبها ديناميك
          'progress.lessonOrder': 1,
        },
      );

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You did not pass. Try again')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final String question = questions[0]['q'] as String;
    final List<String> answers = questions[0]['a'] as List<String>;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Final Quiz',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 32),

            // Answer 1
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => setState(() => score = 1),
                child: Text(answers[0]),
              ),
            ),

            const SizedBox(height: 12),

            // Answer 2
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => setState(() => score = 0),
                child: Text(answers[1]),
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _submitQuiz,
                child: const Text(
                  'Submit Quiz',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
