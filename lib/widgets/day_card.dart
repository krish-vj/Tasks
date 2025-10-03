import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:task_cascade_manager/models/day_model.dart';
import 'package:task_cascade_manager/providers/task_provider.dart';
import 'package:task_cascade_manager/widgets/task_chip.dart';

class DayCard extends StatelessWidget {
  final Day day;
  const DayCard({super.key, required this.day});

  void _showAddTaskDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Task'),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Task description...',
            hintStyle: TextStyle(color: Colors.white54),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white54),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                Provider.of<TaskProvider>(context, listen: false)
                    .addTask(day.id, controller.text.trim());
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
            child: const Text('Add Task', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            // Day Header
            Row(
              children: [
                Text(
                  '${day.dayNumber}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(width: 15),
                Text(
                  DateFormat('d/M').format(day.date),
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const Spacer(),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'add') {
                      _showAddTaskDialog(context);
                    } else if (value == 'delete') {
                      taskProvider.deleteDay(day.id);
                    }
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'add',
                      child: Text('Add Task'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'delete',
                      child: Text('Delete Day'),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(color: Colors.white30),
            // Tasks Container
            SizedBox(
              height: 60,
              child: day.tasks.isEmpty
                  ? const Center(child: Text("No tasks for this day.", style: TextStyle(color: Colors.white70)))
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: day.tasks.length,
                      itemBuilder: (context, index) {
                        final task = day.tasks[index];
                        return TaskChip(dayId: day.id, task: task);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}