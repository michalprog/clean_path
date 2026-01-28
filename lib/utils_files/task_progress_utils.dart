const int maxTaskLevel = 10;
const int earlyLevelMax = 5;
const int earlyLevelStep = 5;
const int lateLevelStep = 10;

const List<String> taskLevelColors = [
  '#4CAF50',
  '#8BC34A',
  '#CDDC39',
  '#FFC107',
  '#FF9800',
  '#FF5722',
  '#F44336',
  '#E91E63',
  '#9C27B0',
  '#673AB7',
  '#3F51B5',
];

const List<String> taskRankTitles = [
  'Ranga 0',
  'Ranga 1',
  'Ranga 2',
  'Ranga 3',
  'Ranga 4',
  'Ranga 5',
  'Ranga 6',
  'Ranga 7',
  'Ranga 8',
  'Ranga 9',
  'Ranga 10',
];

int calculateTaskLevel(int totalTasks) {
  if (totalTasks <= 0) return 0;
  if (totalTasks < earlyLevelMax * earlyLevelStep) {
    return (totalTasks ~/ earlyLevelStep).clamp(0, maxTaskLevel);
  }
  final lateTasks = totalTasks - (earlyLevelMax * earlyLevelStep);
  final lateLevel = lateTasks ~/ lateLevelStep;
  return (earlyLevelMax + lateLevel).clamp(0, maxTaskLevel);
}

int tasksToNextLevel(int totalTasks) {
  final level = calculateTaskLevel(totalTasks);
  if (level >= maxTaskLevel) {
    return 0;
  }
  if (totalTasks < earlyLevelMax * earlyLevelStep) {
    final remainder = totalTasks % earlyLevelStep;
    return earlyLevelStep - remainder;
  }
  final remainder = (totalTasks - (earlyLevelMax * earlyLevelStep)) %
      lateLevelStep;
  return lateLevelStep - remainder;
}

int minTasksForLevel(int level) {
  if (level <= earlyLevelMax) {
    return level * earlyLevelStep;
  }
  return (earlyLevelMax * earlyLevelStep) +
      ((level - earlyLevelMax) * lateLevelStep);
}

int maxTasksForLevel(int level) {
  if (level >= maxTaskLevel) {
    return 999999;
  }
  final minTasks = minTasksForLevel(level);
  if (level < earlyLevelMax) {
    return minTasks + (earlyLevelStep - 1);
  }
  return minTasks + (lateLevelStep - 1);
}