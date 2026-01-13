import 'package:flutter/material.dart';

class LectureVideoPage extends StatelessWidget {
  final String title;

  const LectureVideoPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(child: Icon(Icons.play_circle, size: 64)),
            ),
            const SizedBox(height: 16),
            Text(
              'Lecture description goes here.',
              style: theme.textTheme.bodyMedium,
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.check),
              label: const Text('Mark as Completed'),
            ),
          ],
        ),
      ),
    );
  }
}
