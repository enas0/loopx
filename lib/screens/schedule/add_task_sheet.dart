import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/task_model.dart';
import '../../services/firebase_task_service.dart';

class AddTaskSheet extends StatefulWidget {
  final DateTime selectedDate;
  final Task? existingTask;

  const AddTaskSheet({
    super.key,
    required this.selectedDate,
    this.existingTask,
  });

  @override
  State<AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends State<AddTaskSheet> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  final FirebaseTaskService _taskService = FirebaseTaskService.instance;

  late DateTime _date;
  TimeOfDay _time = TimeOfDay.now();
  RepeatType _repeat = RepeatType.none;
  Color _selectedColor = Colors.blue;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _date = widget.selectedDate;

    if (widget.existingTask != null) {
      final task = widget.existingTask!;
      _titleController.text = task.title;
      _descController.text = task.description;
      _date = task.dateTime;
      _time = TimeOfDay.fromDateTime(task.dateTime);
      _repeat = task.repeat;
      _selectedColor = task.color;
    }
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _date = picked);
  }

  void _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: _time);
    if (picked != null) setState(() => _time = picked);
  }

  Future<void> _submit() async {
    if (_isSaving) return;

    // 🔒 تأكد من تسجيل الدخول
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please login first')));
      return;
    }

    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Task title is required')));
      return;
    }

    setState(() => _isSaving = true);

    try {
      final dateTime = DateTime(
        _date.year,
        _date.month,
        _date.day,
        _time.hour,
        _time.minute,
      );

      final task = Task(
        id: widget.existingTask?.id ?? const Uuid().v4(),
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        dateTime: dateTime,
        repeat: _repeat,
        color: _selectedColor,
      );

      if (widget.existingTask == null) {
        await _taskService.addTask(task);
      } else {
        await _taskService.updateTask(task);
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error saving task: $e')));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        20,
        16,
        MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// TITLE
            TextField(
              controller: _titleController,
              autofocus: true,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              decoration: const InputDecoration(
                hintText: 'What needs to be done?',
                border: InputBorder.none,
              ),
            ),

            const SizedBox(height: 12),

            /// DESCRIPTION
            TextField(
              controller: _descController,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: 'Add more details...',
                border: InputBorder.none,
              ),
            ),

            const SizedBox(height: 16),

            /// DATE & TIME
            Row(
              children: [
                ActionChip(
                  avatar: const Icon(Icons.calendar_today, size: 18),
                  label: Text('${_date.day}/${_date.month}/${_date.year}'),
                  onPressed: _pickDate,
                ),
                const SizedBox(width: 8),
                ActionChip(
                  avatar: const Icon(Icons.access_time, size: 18),
                  label: Text(_time.format(context)),
                  onPressed: _pickTime,
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// REPEAT
            DropdownButtonFormField<RepeatType>(
              initialValue: _repeat,
              decoration: const InputDecoration(labelText: 'Repeat'),
              items: const [
                DropdownMenuItem(
                  value: RepeatType.none,
                  child: Text('No repeat'),
                ),
                DropdownMenuItem(value: RepeatType.daily, child: Text('Daily')),
                DropdownMenuItem(
                  value: RepeatType.weekly,
                  child: Text('Weekly'),
                ),
                DropdownMenuItem(
                  value: RepeatType.monthly,
                  child: Text('Monthly'),
                ),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _repeat = value);
              },
            ),

            const SizedBox(height: 16),

            /// COLOR
            const Text('Task color'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children:
                  [
                    Colors.blue,
                    Colors.green,
                    Colors.orange,
                    Colors.purple,
                    Colors.red,
                  ].map((color) {
                    return GestureDetector(
                      onTap: () => setState(() => _selectedColor = color),
                      child: CircleAvatar(
                        backgroundColor: color,
                        child: _selectedColor == color
                            ? const Icon(Icons.check, color: Colors.white)
                            : null,
                      ),
                    );
                  }).toList(),
            ),

            const SizedBox(height: 24),

            /// ADD / SAVE BUTTON
            ElevatedButton(
              onPressed: _isSaving ? null : _submit,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                backgroundColor: colors.primary,
                foregroundColor: colors.onPrimary,
              ),
              child: _isSaving
                  ? const CircularProgressIndicator()
                  : Text(
                      widget.existingTask == null ? 'Add Task' : 'Save Changes',
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
