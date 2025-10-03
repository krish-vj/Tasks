import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_cascade_manager/models/day_model.dart';
import 'package:task_cascade_manager/models/task_model.dart';
import 'package:uuid/uuid.dart';

class TaskProvider extends ChangeNotifier {
  List<Day> _days = [];
  bool _isLoading = true;
  final Uuid _uuid = Uuid();

  List<Day> get days => _days;
  bool get isLoading => _isLoading;

  TaskProvider() {
    loadDays();
  }

  // --- Core Logic ---

  void addDay() {
    final dayNumber = _days.length + 1;
    final today = DateTime.now();
    final newDate = today.add(Duration(days: _days.length));

    final newDay = Day(
      id: _uuid.v4(),
      dayNumber: dayNumber,
      date: newDate,
      tasks: [],
    );

    _days.add(newDay);
    saveDays();
    notifyListeners();
  }

  void deleteDay(String dayId) {
    _days.removeWhere((day) => day.id == dayId);
    // Re-number the remaining days
    for (int i = 0; i < _days.length; i++) {
      _days[i].dayNumber = i + 1;
    }
    saveDays();
    notifyListeners();
  }

  void addTask(String dayId, String taskText) {
    final day = _days.firstWhere((d) => d.id == dayId);
    final newTask = Task(
      id: _uuid.v4(),
      text: taskText,
    );
    day.tasks.add(newTask);
    saveDays();
    notifyListeners();
  }
  
  void deleteTask(String dayId, String taskId) {
    final day = _days.firstWhere((d) => d.id == dayId);
    day.tasks.removeWhere((task) => task.id == taskId);
    saveDays();
    notifyListeners();
  }

  void toggleTask(String dayId, String taskId) {
    final day = _days.firstWhere((d) => d.id == dayId);
    final taskIndex = day.tasks.indexWhere((t) => t.id == taskId);
    if (taskIndex != -1) {
        day.tasks[taskIndex].isCompleted = !day.tasks[taskIndex].isCompleted;
    }
    saveDays();
    notifyListeners();
  }
  
  // --- Persistence Logic ---

  Future<void> saveDays() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> daysJson = _days.map((day) => jsonEncode(day.toJson())).toList();
    await prefs.setStringList('taskDays', daysJson);
  }

  Future<void> loadDays() async {
    final prefs = await SharedPreferences.getInstance();
    final daysJson = prefs.getStringList('taskDays');

    if (daysJson != null) {
      _days = daysJson.map((dayString) => Day.fromJson(jsonDecode(dayString))).toList();
    }
    _isLoading = false;
    notifyListeners();
  }
}