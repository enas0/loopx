import 'package:flutter/material.dart';

import '../../models/task_model.dart';
import '../../services/task_service.dart';
import '../../widgets/app_bottom_nav.dart';
import 'add_task_sheet.dart';
import 'task_card.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final TaskService _taskService = TaskService.instance;

  DateTime _selectedDate = DateTime.now();
  DateTime _focusedMonth = DateTime.now();

  void _openAddTaskSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => AddTaskSheet(
        selectedDate: _selectedDate, // ✅ اليوم المختار
        onAdd: (Task task) {
          setState(() {
            _taskService.add(task);
            // بعد الإضافة نرجّع التحديد على تاريخ التاسك
            _selectedDate = task.dateTime;
            _focusedMonth = DateTime(task.dateTime.year, task.dateTime.month);
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final List<Task> dayTasks = _taskService.getByDate(_selectedDate);

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
            /// ===== Calendar Card =====
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Month Header
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
                            icon: Icon(
                              Icons.chevron_left,
                              color: colors.onSurfaceVariant,
                            ),
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
                            icon: Icon(
                              Icons.chevron_right,
                              color: colors.onSurfaceVariant,
                            ),
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

                  /// Week Days
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

                  /// Calendar Grid
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

                      if (index < offset) {
                        return const SizedBox.shrink();
                      }

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
                              fontWeight: FontWeight.w500,
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

            /// ===== Tasks =====
            Expanded(
              child: dayTasks.isEmpty
                  ? Center(
                      child: Text(
                        'No tasks for this day',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: dayTasks.length,
                      itemBuilder: (_, index) =>
                          TaskCard(task: dayTasks[index]),
                    ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
    );
  }

  // ===== Helpers =====

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

/// Week Day Widget
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
