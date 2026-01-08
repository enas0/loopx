import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../models/task_model.dart';

class AddTaskSheet extends StatefulWidget {
  final DateTime selectedDate;
  final void Function(Task task) onAdd;

  const AddTaskSheet({
    super.key,
    required this.selectedDate,
    required this.onAdd,
  });

  @override
  State<AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends State<AddTaskSheet> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  late DateTime _date;
  TimeOfDay _time = TimeOfDay.now();
  RepeatType _repeat = RepeatType.none;

  Color _selectedColor = Colors.blue;

  @override
  void initState() {
    super.initState();
    _date = widget.selectedDate;
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() => _date = picked);
    }
  }

  void _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: _time);

    if (picked != null) {
      setState(() => _time = picked);
    }
  }

  void _submit() {
    if (_titleController.text.trim().isEmpty) return;

    final dateTime = DateTime(
      _date.year,
      _date.month,
      _date.day,
      _time.hour,
      _time.minute,
    );

    widget.onAdd(
      Task(
        id: const Uuid().v4(),
        title: _titleController.text,
        description: _descController.text,
        dateTime: dateTime,
        repeat: _repeat,
        color: _selectedColor,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Task title'),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: _descController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                TextButton.icon(
                  onPressed: _pickDate,
                  icon: const Icon(Icons.calendar_today),
                  label: Text('${_date.day}/${_date.month}/${_date.year}'),
                ),
                TextButton.icon(
                  onPressed: _pickTime,
                  icon: const Icon(Icons.access_time),
                  label: Text(_time.format(context)),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// ✅ FIXED: initialValue بدل value
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
                if (value != null) {
                  setState(() => _repeat = value);
                }
              },
            ),

            const SizedBox(height: 16),

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
                      onTap: () {
                        setState(() => _selectedColor = color);
                      },
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

            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                backgroundColor: colors.primary,
                foregroundColor: colors.onPrimary,
              ),
              child: const Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }
}
