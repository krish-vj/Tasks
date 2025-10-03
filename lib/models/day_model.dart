import 'package:task_cascade_manager/models/task_model.dart';


class Day {
  final String id;
  int dayNumber;
  final DateTime date;
  List<Task> tasks;

  Day({
    required this.id,
    required this.dayNumber,
    required this.date,
    required this.tasks,
  });

  factory Day.fromJson(Map<String, dynamic> json) {
    var taskList = json['tasks'] as List;
    List<Task> tasks = taskList.map((i) => Task.fromJson(i)).toList();
    
    return Day(
      id: json['id'],
      dayNumber: json['dayNumber'],
      date: DateTime.parse(json['date']),
      tasks: tasks,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dayNumber': dayNumber,
      'date': date.toIso8601String(),
      'tasks': tasks.map((task) => task.toJson()).toList(),
    };
  }
}