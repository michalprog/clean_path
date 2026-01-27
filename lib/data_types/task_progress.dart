import '/enums/enums.dart';

class TaskProgress {
  final DailyTaskType taskType;
  final int level;
  final int streak;
  final int totalTasksCompleted;
  final int tasksToNextLevel;

  const TaskProgress({
    required this.taskType,
    required this.level,
    required this.streak,
    required this.totalTasksCompleted,
    required this.tasksToNextLevel,
  });

  int get id => taskType.index + 1;

  factory TaskProgress.fromMap(Map<String, dynamic> map) {
    final idValue = map['id'] as int?;
    final resolvedIndex = (idValue ?? 1) - 1;
    final taskType = DailyTaskType.values.firstWhere(
          (type) => type.index == resolvedIndex,
      orElse: () => DailyTaskType.hydration,
    );
    return TaskProgress(
      taskType: taskType,
      level: map['level'] as int,
      streak: map['streak'] as int,
      totalTasksCompleted: map['total_tasks_completed'] as int,
      tasksToNextLevel: map['tasks_to_next_level'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'id': id,
      'level': level,
      'streak': streak,
      'total_tasks_completed': totalTasksCompleted,
      'tasks_to_next_level': tasksToNextLevel,
    };
    return map;
  }

  TaskProgress copyWith({
    DailyTaskType? taskType,
    int? level,
    int? streak,
    int? totalTasksCompleted,
    int? tasksToNextLevel,
  }) {
    return TaskProgress(
      taskType: taskType ?? this.taskType,
      level: level ?? this.level,
      streak: streak ?? this.streak,
      totalTasksCompleted: totalTasksCompleted ?? this.totalTasksCompleted,
      tasksToNextLevel: tasksToNextLevel ?? this.tasksToNextLevel,
    );
  }
}