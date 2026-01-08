import '../models/task_model.dart';

class TaskService {
  TaskService._();
  static final TaskService instance = TaskService._();

  final List<Task> _tasks = [];

  void add(Task task) {
    _tasks.add(task);
  }

  void remove(String id) {
    _tasks.removeWhere((task) => task.id == id);
  }

  List<Task> getAll() {
    return List.unmodifiable(_tasks);
  }

  List<Task> getByDate(DateTime date) {
    return _tasks.where((task) {
      return task.dateTime.year == date.year &&
          task.dateTime.month == date.month &&
          task.dateTime.day == date.day;
    }).toList();
  }

  void clear() {
    _tasks.clear();
  }
}
