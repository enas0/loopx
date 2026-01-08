import 'package:flutter/material.dart';

enum RepeatType { none, daily, weekly, monthly }

class Task {
  final String id;
  final String title;
  final String description;
  final DateTime dateTime;
  final RepeatType repeat;
  final Color color;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.repeat,
    required this.color,
  });
}
