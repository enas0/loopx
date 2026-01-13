import 'package:flutter/material.dart';

import '../../models/task_model.dart';
import '../../services/firebase_task_service.dart';
import '../../widgets/app_bottom_nav.dart';
import 'add_task_sheet.dart';
import 'task_card.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final FirebaseTaskService _taskService = FirebaseTaskService.instance;

  DateTime _selectedDate = DateTime.now();
  DateTime _focusedMonth = DateTime.now();

  // ADD TASK
  void _openAddTaskSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => AddTaskSheet(selectedDate: _selectedDate),
    );
  }

  // EDIT TASK
  void _openEditTaskSheet(Task task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) =>
          AddTaskSheet(selectedDate: task.dateTime, existingTask: task),
    );
  }

  // TASK FILTER WITH REPEAT ✅
  List<Task> _tasksForSelectedDate(List<Task> tasks) {
    final selected = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
    );

    return tasks.where((task) {
      final taskDate = DateTime(
        task.dateTime.year,
        task.dateTime.month,
        task.dateTime.day,
      );

      if (_isSameDay(taskDate, selected)) return true;

      switch (task.repeat) {
        case RepeatType.daily:
          return selected.isAfter(taskDate);

        case RepeatType.weekly:
          return selected.isAfter(taskDate) &&
              selected.weekday == taskDate.weekday;

        case RepeatType.monthly:
          return selected.isAfter(taskDate) && selected.day == taskDate.day;

        case RepeatType.none:
          return false;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'TO DO LIST',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: _openAddTaskSheet),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // CALENDAR
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Month header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_monthName(_focusedMonth.month)} ${_focusedMonth.year}',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.chevron_left),
                            onPressed: () {
                              setState(() {
                                _focusedMonth = DateTime(
                                  _focusedMonth.year,
                                  _focusedMonth.month - 1,
                                );
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.chevron_right),
                            onPressed: () {
                              setState(() {
                                _focusedMonth = DateTime(
                                  _focusedMonth.year,
                                  _focusedMonth.month + 1,
                                );
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _WeekDay('SUN'),
                      _WeekDay('MON'),
                      _WeekDay('TUE'),
                      _WeekDay('WED'),
                      _WeekDay('THU'),
                      _WeekDay('FRI'),
                      _WeekDay('SAT'),
                    ],
                  ),

                  const SizedBox(height: 12),

                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount:
                        _daysInMonth(_focusedMonth) +
                        _firstWeekdayOffset(_focusedMonth),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 7,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                        ),
                    itemBuilder: (context, index) {
                      final offset = _firstWeekdayOffset(_focusedMonth);

                      if (index < offset) return const SizedBox.shrink();

                      final day = index - offset + 1;
                      final date = DateTime(
                        _focusedMonth.year,
                        _focusedMonth.month,
                        day,
                      );

                      final isSelected = _isSameDay(date, _selectedDate);

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedDate = date;
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? colors.primary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '$day',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: isSelected
                                  ? colors.onPrimary
                                  : colors.onSurface,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // TASKS
            Expanded(
              child: StreamBuilder<List<Task>>(
                stream: _taskService.watchTasks(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final tasks = snapshot.data ?? [];
                  final dayTasks = _tasksForSelectedDate(tasks);

                  if (dayTasks.isEmpty) {
                    return Center(
                      child: Text(
                        'No tasks for this day',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: dayTasks.length,
                    itemBuilder: (_, index) {
                      final task = dayTasks[index];

                      return TaskCard(
                        task: task,
                        onDelete: () async {
                          await _taskService.deleteTask(task.id);
                        },
                        onTap: () => _openEditTaskSheet(task),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
    );
  }

  // HELPERS

  int _daysInMonth(DateTime date) {
    final firstDayNextMonth = DateTime(date.year, date.month + 1, 1);
    return firstDayNextMonth.subtract(const Duration(days: 1)).day;
  }

  int _firstWeekdayOffset(DateTime date) {
    final firstDayOfMonth = DateTime(date.year, date.month, 1);
    return firstDayOfMonth.weekday % 7;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _monthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }
}

class _WeekDay extends StatelessWidget {
  final String text;
  const _WeekDay(this.text);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Text(
      text,
      style: TextStyle(fontSize: 12, color: colors.onSurfaceVariant),
    );
  }
}
