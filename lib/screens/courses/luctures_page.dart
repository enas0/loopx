import 'package:flutter/material.dart';

class LucturesPage extends StatelessWidget {
  const LucturesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Lectures')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Frontend Development',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            _lectureTile('Introduction to HTML', '10 min'),
            _lectureTile('CSS Fundamentals', '18 min'),
            _lectureTile('JavaScript Basics', '25 min'),
            _lectureTile('React Overview', '20 min'),
          ],
        ),
      ),
    );
  }

  Widget _lectureTile(String title, String duration) {
    return ListTile(
      leading: const Icon(Icons.play_circle_outline),
      title: Text(title),
      subtitle: Text(duration),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}
