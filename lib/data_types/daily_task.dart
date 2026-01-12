class DailyTask {
  final int? id;
  final String title;
  final DateTime? lastCompleted;

  const DailyTask({
    this.id,
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
    int? id,
    String? title,
    DateTime? lastCompleted,
  }) {
    return DailyTask(
      id: id ?? this.id,
      title: title ?? this.title,
      lastCompleted: lastCompleted ?? this.lastCompleted,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'last_completed': lastCompleted?.toIso8601String(),
    };
  }

  factory DailyTask.fromMap(Map<String, Object?> map) {
    return DailyTask(
      id: map['id'] as int?,
      title: map['title'] as String,
      lastCompleted: map['last_completed'] != null
          ? DateTime.parse(map['last_completed'] as String)
          : null,
    );
  }
}