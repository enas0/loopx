import 'package:flutter/material.dart';
import 'lecture_video_page.dart';

class LecturesPage extends StatelessWidget {
  final String moduleTitle;

  const LecturesPage({super.key, required this.moduleTitle});

  @override
  Widget build(BuildContext context) {
    final lectures = [
      {'title': 'Introduction', 'duration': '5:20'},
      {'title': 'Core Concepts', 'duration': '12:40'},
      {'title': 'Practice', 'duration': '8:10'},
    ];

    return Scaffold(
      appBar: AppBar(title: Text(moduleTitle)),
      body: ListView.builder(
        itemCount: lectures.length,
        itemBuilder: (context, index) {
          final lecture = lectures[index];

          return ListTile(
            leading: const Icon(Icons.play_circle),
            title: Text(lecture['title'] as String),
            subtitle: Text(lecture['duration'] as String),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      LectureVideoPage(title: lecture['title'] as String),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
