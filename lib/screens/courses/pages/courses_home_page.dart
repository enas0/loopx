import 'package:flutter/material.dart';
import 'learning_path_page.dart';

class CoursesHomePage extends StatelessWidget {
  const CoursesHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final courses = [
      {
        'title': 'Web Development',
        'subtitle': 'HTML, CSS, JS, React',
        'icon': Icons.language,
      },
      {
        'title': 'Mobile Development',
        'subtitle': 'Flutter, Android, iOS',
        'icon': Icons.phone_android,
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Courses')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: Icon(
                course['icon'] as IconData,
                color: theme.colorScheme.primary,
              ),
              title: Text(course['title'] as String),
              subtitle: Text(course['subtitle'] as String),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        LearningPathPage(title: course['title'] as String),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
