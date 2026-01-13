import 'package:flutter/material.dart';
import 'lectures_page.dart';

class LearningPathPage extends StatelessWidget {
  final String title;

  const LearningPathPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final modules = [
      {'title': 'HTML Basics', 'done': true},
      {'title': 'CSS Fundamentals', 'done': true},
      {'title': 'JavaScript Core', 'done': false},
      {'title': 'React Basics', 'done': false},
    ];

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: modules.length,
        itemBuilder: (context, index) {
          final module = modules[index];
          final unlocked = index == 0 || modules[index - 1]['done'] == true;

          return Column(
            children: [
              GestureDetector(
                onTap: unlocked
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LecturesPage(
                              moduleTitle: module['title'] as String,
                            ),
                          ),
                        );
                      }
                    : null,
                child: CircleAvatar(
                  radius: 36,
                  backgroundColor: unlocked
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).disabledColor,
                  child: Icon(
                    module['done'] == true
                        ? Icons.check
                        : unlocked
                        ? Icons.play_arrow
                        : Icons.lock,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(module['title'] as String),
              const SizedBox(height: 32),
            ],
          );
        },
      ),
    );
  }
}
