const int maxTaskLevel = 10;

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

int tasksRequiredForNextLevel(int level) {
  if (level <= 1) return 2;
  if (level <= 4) return 3;
  if (level <= 10) return 5;
  return 7;
}

int calculateTaskLevel(int totalTasks) {
  if (totalTasks <= 0) return 0;

  var remainingTasks = totalTasks;
  var level = 0;

  while (remainingTasks >= tasksRequiredForNextLevel(level)) {
    remainingTasks -= tasksRequiredForNextLevel(level);
    level++;
  }

  return level;
}

int tasksToNextLevel(int totalTasks) {
  if (totalTasks < 0) {
    return tasksRequiredForNextLevel(0);
  }

  final level = calculateTaskLevel(totalTasks);
  final minTasksForCurrentLevel = minTasksForLevel(level);
  final currentLevelProgress = totalTasks - minTasksForCurrentLevel;
  final levelRequirement = tasksRequiredForNextLevel(level);

  return levelRequirement - currentLevelProgress;
}

int minTasksForLevel(int level) {
  if (level <= 0) return 0;

  var minTasks = 0;
  for (var currentLevel = 0; currentLevel < level; currentLevel++) {
    minTasks += tasksRequiredForNextLevel(currentLevel);
  }

  return minTasks;
}

int maxTasksForLevel(int level) {
  if (level >= maxTaskLevel) {
    return 999999;
  }

  final minTasks = minTasksForLevel(level);
  final levelRequirement = tasksRequiredForNextLevel(level);

  return minTasks + (levelRequirement - 1);
}