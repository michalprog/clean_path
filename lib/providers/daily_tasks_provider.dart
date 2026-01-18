import 'package:flutter/material.dart';
import '/data_types/daily_task.dart';
import '/sqlflite/daily_tasks_dao.dart';

class DailyTasksProvider extends ChangeNotifier {
  final DailyTasksDao dailyTasksDao = DailyTasksDao();

  List<DailyTask> _tasks = [];

  List<DailyTask> get tasks => _tasks;

  Future<void> initialize() async {
    await dailyTasksDao.ensureInitialized();
    await fetchTasks();
  }

  Future<void> fetchTasks() async {
    _tasks = await dailyTasksDao.getDailyTasks();
    notifyListeners();
  }
  Future<Map<int, int>> fetchCompletionCounts() {
    return dailyTasksDao.getCompletionCounts();
  }
  Future<List<DateTime>> fetchCompletionDatesForType(int type) {
    return dailyTasksDao.getCompletionDatesForType(type);
  }


  Future<void> saveTask(DailyTask task) async {
    final updated = await dailyTasksDao.insertDailyTasks(task);
    _tasks = _tasks
        .map((existing) =>
    existing.type == updated.type ? updated : existing)
        .toList();
    notifyListeners();
  }

  Future<void> markCompleted(DailyTask task) async {
    final updated = task.copyWith(lastCompleted: DateTime.now());
    await dailyTasksDao.update(updated);
    _tasks = _tasks
        .map((existing) =>
    existing.type == task.type ? updated : existing)
        .toList();
    notifyListeners();
  }
}