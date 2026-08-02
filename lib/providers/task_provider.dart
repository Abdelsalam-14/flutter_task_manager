import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  bool _isDarkMode = false;
  String _searchQuery = '';
  String _statusFilter = 'All'; // All, Active, Completed
  String _priorityFilter = 'All'; // All, Low, Medium, High

  List<Task> get tasks {
    return _tasks.where((task) {
      // Apply search query
      final matchesSearch = task.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          task.description.toLowerCase().contains(_searchQuery.toLowerCase());
      
      // Apply status filter
      bool matchesStatus = true;
      if (_statusFilter == 'Active') {
        matchesStatus = !task.isCompleted;
      } else if (_statusFilter == 'Completed') {
        matchesStatus = task.isCompleted;
      }

      // Apply priority filter
      bool matchesPriority = true;
      if (_priorityFilter != 'All') {
        final priorityString = task.priority.toString().split('.').last.toLowerCase();
        matchesPriority = priorityString == _priorityFilter.toLowerCase();
      }

      return matchesSearch && matchesStatus && matchesPriority;
    }).toList();
  }

  // Get raw counts
  int get totalTasksCount => _tasks.length;
  int get completedTasksCount => _tasks.where((t) => t.isCompleted).length;
  double get completionRate => _tasks.isEmpty ? 0.0 : completedTasksCount / totalTasksCount;

  bool get isDarkMode => _isDarkMode;
  String get searchQuery => _searchQuery;
  String get statusFilter => _statusFilter;
  String get priorityFilter => _priorityFilter;

  TaskProvider() {
    _loadFromPrefs();
  }

  // SharedPreferences keys
  static const String _tasksKey = 'user_tasks_list';
  static const String _themeKey = 'user_theme_preference';

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load Theme
    _isDarkMode = prefs.getBool(_themeKey) ?? false;

    // Load Tasks
    final tasksJson = prefs.getString(_tasksKey);
    if (tasksJson != null) {
      try {
        final List<dynamic> decodedList = json.decode(tasksJson);
        _tasks = decodedList.map((item) => Task.fromMap(item)).toList();
      } catch (e) {
        _tasks = [];
      }
    }
    notifyListeners();
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final String tasksJson = json.encode(_tasks.map((t) => t.toMap()).toList());
    await prefs.setString(_tasksKey, tasksJson);
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, _isDarkMode);
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setStatusFilter(String filter) {
    _statusFilter = filter;
    notifyListeners();
  }

  void setPriorityFilter(String filter) {
    _priorityFilter = filter;
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    _tasks.add(task);
    notifyListeners();
    await _saveToPrefs();
  }

  Future<void> updateTask(Task updatedTask) async {
    final index = _tasks.indexWhere((task) => task.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      notifyListeners();
      await _saveToPrefs();
    }
  }

  Future<void> toggleTaskStatus(String id) async {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(isCompleted: !_tasks[index].isCompleted);
      notifyListeners();
      await _saveToPrefs();
    }
  }

  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
    await _saveToPrefs();
  }
}
