import 'package:flutter/material.dart';

import '../../widgets/app_bottom_nav.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: colors.primaryContainer,
                    child: Icon(
                      Icons.person,
                      size: 48,
                      color: colors.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Ayham Ahmad',
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Computer Science Student | Flutter & Web Developer',
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            _section(
              context,
              title: 'About',
              content:
                  'Motivated computer science student passionate about building '
                  'modern applications and continuously learning new technologies.',
            ),

            _section(
              context,
              title: 'Education',
              content: 'Bachelor of Computer Science\nUniversity of Technology',
            ),

            _skillsSection(context),

            _section(
              context,
              title: 'Experience',
              content:
                  '• Flutter Developer – Academic Projects\n'
                  '• Web Developer – Personal Projects',
            ),

            _section(
              context,
              title: 'Projects',
              content:
                  '• LOOPX – Study & Productivity App\n'
                  '• Portfolio Website\n'
                  '• Mobile Task Manager',
            ),
          ],
        ),
      ),

      ///BottomNav Widget
      bottomNavigationBar: const AppBottomNav(currentIndex: 4),
    );
  }

  // ================= SECTION =================
  Widget _section(
    BuildContext context, {
    required String title,
    required String content,
  }) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(content, style: textTheme.bodyMedium),
        ],
      ),
    );
  }

  // ================= SKILLS =================
  Widget _skillsSection(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final skills = [
      'Flutter',
      'Dart',
      'JavaScript',
      'React',
      'Node.js',
      'ASP.NET',
      'SQL',
    ];

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Skills',
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: skills
                .map(
                  (skill) => Chip(
                    label: Text(skill),
                    backgroundColor: colors.primaryContainer,
                    labelStyle: TextStyle(color: colors.onPrimaryContainer),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
