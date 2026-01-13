import 'package:flutter/material.dart';
import 'package:loopx/screens/courses/courses_page.dart';

import 'pages/learning_path_page.dart';
import 'pages/lectures_page.dart';
import 'pages/lecture_video_page.dart';
import 'pages/hackathons_page.dart';
import 'pages/projects_page.dart';

class CoursesRoutes {
  static const courses = '/courses';
  static const path = '/courses/path';
  static const lectures = '/courses/lectures';
  static const lectureVideo = '/courses/lecture-video';
  static const hackathons = '/courses/hackathons';
  static const projects = '/courses/projects';

  static Route<dynamic> generate(RouteSettings settings) {
    switch (settings.name) {
      case courses:
        return MaterialPageRoute(builder: (_) => const CoursesPage());

      case path:
        final title = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => LearningPathPage(title: title),
        );

      case lectures:
        final moduleTitle = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => LecturesPage(moduleTitle: moduleTitle),
        );

      case lectureVideo:
        final title = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => LectureVideoPage(title: title),
        );

      case hackathons:
        return MaterialPageRoute(builder: (_) => const HackathonsPage());

      case projects:
        return MaterialPageRoute(builder: (_) => const ProjectsPage());

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Route not found'))),
        );
    }
  }
}
