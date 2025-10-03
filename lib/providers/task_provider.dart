import 'dart:convert';
import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
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

  // --- Import Logic ---

  Future<String> importFromExcel() async {
    try {
      // 1. Pick file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
      );

      if (result == null || result.files.single.bytes == null) {
        return "Import cancelled.";
      }

      // 2. Read file bytes
      Uint8List bytes = result.files.single.bytes!;
      var excel = Excel.decodeBytes(bytes);

      List<Day> importedDays = [];
      var sheet = excel.tables[excel.tables.keys.first]; // Get the first sheet

      if (sheet == null) {
        return "Error: Could not find a sheet in the Excel file.";
      }
      
      // 3. Loop through rows (skip header row at index 0)
      for (int i = 1; i < sheet.rows.length; i++) {
        var row = sheet.rows[i];
        
        try {
          // Parse data from cells
          final dateValue = row[0]?.value;
          final dayNumberValue = row[1]?.value;
          final tasksValue = row[2]?.value;

          if (dateValue == null || dayNumberValue == null) continue;

          // Parse Date (assuming YYYY-MM-DD format)
          final date = DateTime.parse(dateValue.toString());
          
          // Parse Day Number
          final dayNumber = int.parse(dayNumberValue.toString().split('.').first);
          
          // Parse Tasks
          List<Task> tasks = [];
          if (tasksValue != null) {
            String tasksString = tasksValue.toString();
            tasks = tasksString.split(',').map((text) {
              String trimmedText = text.trim();
              if (trimmedText.isNotEmpty) {
                return Task(id: _uuid.v4(), text: trimmedText);
              }
              return null;
            }).whereType<Task>().toList();
          }

          importedDays.add(Day(
            id: _uuid.v4(),
            dayNumber: dayNumber,
            date: date,
            tasks: tasks,
          ));

        } catch (e) {
          debugPrint("Error processing row $i: $e");
          // Skip rows with parsing errors
          continue;
        }
      }

      if (importedDays.isEmpty) {
        return "No valid data found to import.";
      }

      // 4. Replace current data with imported data
      _days = importedDays;
      saveDays();
      notifyListeners();
      return "Successfully imported ${importedDays.length} days.";

    } catch (e) {
      debugPrint("Import failed: $e");
      return "Import failed. Please check the file format.";
    }
  }

  // --- Core Logic ---

  void addMultipleDays(int count) {
    if (count <= 0) return;

    // Get the last date before the loop starts, or use yesterday's date if the list is empty.
    final DateTime lastDate = _days.isEmpty ? DateTime.now().subtract(const Duration(days: 1)) : _days.last.date;

    for (int i = 0; i < count; i++) {
      final dayNumber = _days.length + 1;
      // Increment date from the last known date.
      final newDate = lastDate.add(Duration(days: i + 1));

      final newDay = Day(
        id: _uuid.v4(),
        dayNumber: dayNumber,
        date: newDate,
        tasks: [],
      );
      _days.add(newDay);
    }

    saveDays();
    notifyListeners();
  }

  void deleteDay(String dayId) {
    _days.removeWhere((day) => day.id == dayId);
    for (int i = 0; i < _days.length; i++) {
      _days[i].dayNumber = i + 1;
    }
    saveDays();
    notifyListeners();
  }

  void addTask(String dayId, String taskText) {
    final day = _days.firstWhere((d) => d.id == dayId);
    final newTask = Task(id: _uuid.v4(), text: taskText);
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
