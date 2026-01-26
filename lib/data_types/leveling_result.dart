import '/data_types/user.dart';

class LevelingResult {
  final User user;
  final int gainedXp;
  final bool levelUp;

  const LevelingResult({
    required this.user,
    required this.gainedXp,
    required this.levelUp,
  });
}