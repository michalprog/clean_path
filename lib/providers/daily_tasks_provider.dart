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
    if (task.id == null) {
      final created = await _dailyTasksDao.insert(task);
      _tasks = [..._tasks, created];
    } else {
      await _dailyTasksDao.update(task);
      _tasks = _tasks
          .map((existing) => existing.id == task.id ? task : existing)
          .toList();
    }
    notifyListeners();
  }

  Future<void> markCompleted(DailyTask task) async {
    final updated = task.copyWith(lastCompleted: DateTime.now());
    await _dailyTasksDao.update(updated);
    _tasks = _tasks
        .map((existing) => existing.id == task.id ? updated : existing)
        .toList();
    notifyListeners();
  }
}