import 'package:flutter/material.dart';
import '/data_types/daily_task.dart';
import '/sqlflite/daily_tasks_dao.dart';

class DailyTasksProvider extends ChangeNotifier {
  final DailyTasksDao _dailyTasksDao = DailyTasksDao();

  List<DailyTask> _tasks = [];

  List<DailyTask> get tasks => _tasks;

  Future<void> initialize() async {
    await _dailyTasksDao.ensureInitialized();
    await fetchTasks();
  }

  Future<void> fetchTasks() async {
    _tasks = await _dailyTasksDao.getAll();
    notifyListeners();
  }

  Future<void> saveTask(DailyTask task) async {
    final updated = await _dailyTasksDao.insert(task);
    _tasks = _tasks
        .map((existing) =>
    existing.type == updated.type ? updated : existing)
        .toList();
    notifyListeners();
  }

  Future<void> markCompleted(DailyTask task) async {
    final updated = task.copyWith(lastCompleted: DateTime.now());
    await _dailyTasksDao.update(updated);
    _tasks = _tasks
        .map((existing) =>
    existing.type == task.type ? updated : existing)
        .toList();
    notifyListeners();
  }
}