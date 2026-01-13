import 'package:flutter/material.dart';
import '../../widgets/app_bottom_nav.dart';
import '../courses/pages/learning_path_page.dart';

class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Courses')),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Learning Paths',
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose a path and start learning step by step',
            style: textTheme.bodyMedium?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),

          _pathCard(
            context,
            icon: Icons.code,
            title: 'Web Development',
            description: 'HTML • CSS • JavaScript • React',
          ),
          _pathCard(
            context,
            icon: Icons.smartphone,
            title: 'Mobile Development',
            description: 'Flutter • Android • iOS',
          ),
          _pathCard(
            context,
            icon: Icons.storage,
            title: 'Backend Development',
            description: 'Node.js • ASP.NET • Databases',
          ),
          _pathCard(
            context,
            icon: Icons.security,
            title: 'Cyber Security',
            description: 'Networks • Security Basics',
          ),
          _pathCard(
            context,
            icon: Icons.analytics,
            title: 'Data Structures',
            description: 'Algorithms • Problem Solving',
          ),
        ],
      ),

      /// Bottom Navigation
      bottomNavigationBar: const AppBottomNav(currentIndex: 2),
    );
  }

  // LEARNING PATH CARD
  Widget _pathCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => LearningPathPage(title: title)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.outlineVariant),
        ),
        child: Row(
          children: [
            Icon(icon, size: 36, color: colors.primary),
            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: textTheme.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: colors.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
