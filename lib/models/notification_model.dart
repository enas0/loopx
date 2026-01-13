class AppNotification {
  final String id;
  final String title;
  final String body;
  final String? taskId;
  final DateTime dateTime;
  final bool read;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.dateTime,
    required this.read,
    this.taskId,
  });
}
