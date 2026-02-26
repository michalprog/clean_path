import 'package:clean_path/utils_files/task_progress_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('tasksRequiredForNextLevel', () {
    test('returns 2 for levels up to 1', () {
      expect(tasksRequiredForNextLevel(0), 2);
      expect(tasksRequiredForNextLevel(1), 2);
    });

    test('returns 3 for levels 2-4', () {
      expect(tasksRequiredForNextLevel(2), 3);
      expect(tasksRequiredForNextLevel(4), 3);
    });

    test('returns 5 for levels 5-10 and 7 above 10', () {
      expect(tasksRequiredForNextLevel(5), 5);
      expect(tasksRequiredForNextLevel(10), 5);
      expect(tasksRequiredForNextLevel(11), 7);
    });
  });

  group('level calculations', () {
    test('calculateTaskLevel handles boundaries', () {
      expect(calculateTaskLevel(-1), 0);
      expect(calculateTaskLevel(0), 0);
      expect(calculateTaskLevel(1), 0);
      expect(calculateTaskLevel(2), 1);
      expect(calculateTaskLevel(4), 2);
      expect(calculateTaskLevel(7), 3);
    });

    test('minTasksForLevel sums prior level requirements', () {
      expect(minTasksForLevel(0), 0);
      expect(minTasksForLevel(1), 2);
      expect(minTasksForLevel(2), 4);
      expect(minTasksForLevel(5), 13);
    });

    test('tasksToNextLevel returns remaining tasks in current level', () {
      expect(tasksToNextLevel(-3), 2);
      expect(tasksToNextLevel(0), 2);
      expect(tasksToNextLevel(1), 1);
      expect(tasksToNextLevel(2), 2);
      expect(tasksToNextLevel(4), 3);
      expect(tasksToNextLevel(5), 2);
    });

    test('maxTasksForLevel handles normal and capped levels', () {
      expect(maxTasksForLevel(0), 1);
      expect(maxTasksForLevel(2), 6);
      expect(maxTasksForLevel(maxTaskLevel), 999999);
      expect(maxTasksForLevel(maxTaskLevel + 1), 999999);
    });
  });
}