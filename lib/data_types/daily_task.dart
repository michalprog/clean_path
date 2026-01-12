class DailyTask {
  final int type;
  final String title;
  final DateTime? lastCompleted;

  const DailyTask({
    required this.type,
    required this.title,
    this.lastCompleted,
  });

  bool get isCompletedToday {
    if (lastCompleted == null) return false;
    final now = DateTime.now();
    return lastCompleted!.year == now.year &&
        lastCompleted!.month == now.month &&
        lastCompleted!.day == now.day;
  }

  DailyTask copyWith({
    DateTime? lastCompleted,
  }) {
    return DailyTask(
      type: type,
      title: title,
      lastCompleted: lastCompleted ?? this.lastCompleted,
    );
  }

  Map<String, Object?> toCompletionMap(DateTime completionDate) {
    return {
      'type': type,
      'date': completionDate.toIso8601String(),
    };
  }
}