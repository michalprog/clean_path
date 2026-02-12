import '/data_types/leveling_result.dart';
import '/data_types/user.dart';
import '/enums/enums.dart';

abstract class LevelingService {
  LevelingResult applyAction({
    required User user,
    required LevelingAction action,
  });
}

class DefaultLevelingService implements LevelingService {
  const DefaultLevelingService();

  @override
  LevelingResult applyAction({
    required User user,
    required LevelingAction action,
  }) {
    final gainedXp = _xpForAction(action);
    final updatedXp = user.xp + gainedXp;
    final levelResult = _applyLevelProgress(totalXp: updatedXp);
    final updatedUser = user.copyWith(
      xp: levelResult.totalXp,
      level: levelResult.level,
    );
    return LevelingResult(
      user: updatedUser,
      gainedXp: gainedXp,
      levelUp: levelResult.level > user.level,
    );
  }

  int _xpForAction(LevelingAction action) {
    switch (action) {
      case LevelingAction.dailyTaskCompleted:
        return 10;
      case LevelingAction.achievementUnlocked:
        return 50;
      case LevelingAction.timerDayCompleted:
        return 1;
    }
  }

  _LevelProgress _applyLevelProgress({
    required int totalXp,
  }) {
    final level = totalXp ~/ xpPerLevel;
    return _LevelProgress(level: level, totalXp: totalXp);
  }
}

class _LevelProgress {
  final int level;
  final int totalXp;

  const _LevelProgress({
    required this.level,
    required this.totalXp,
  });
}

const int xpPerLevel = 100;