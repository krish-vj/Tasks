import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_cascade_manager/models/task_model.dart';
import 'package:task_cascade_manager/providers/task_provider.dart';

class TaskChip extends StatelessWidget {
  final String dayId;
  final Task task;
  const TaskChip({super.key, required this.dayId, required this.task});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      padding: const EdgeInsets.only(left: 8, right: 4),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(
            value: task.isCompleted,
            onChanged: (bool? value) {
              taskProvider.toggleTask(dayId, task.id);
            },
            activeColor: Colors.white,
            checkColor: Colors.black,
            side: const BorderSide(color: Colors.white),
            visualDensity: VisualDensity.compact,
          ),
          Flexible(
            child: Text(
              task.text,
              style: TextStyle(
                decoration: task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                color: task.isCompleted ? Colors.white70 : Colors.white,
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 16, color: Colors.white),
            onPressed: () {
              taskProvider.deleteTask(dayId, task.id);
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            splashRadius: 18,
          ),
        ],
      ),
    );
  }
}