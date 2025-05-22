import 'dart:math';
import '/data_types/record.dart';
import '/enums/enums.dart';
class StatisticUtils {

  static bool isActiveRecord(List<Record> records) {
    return records.any((record) => record.isActive);
  }
  static List<Record> getActiveRecords(List<Record> records) {
    return records.where((r) => r.isActive).toList();
  }
  static List<Record> getRecordsByType(List<Record> records, AddictionTypes type) {
    return records.where((r) => r.type == type).toList();
  }
  static int getActiveRecordDuration(List<Record> records)
  {
      final activeRecords = records.where((r) => r.isActive).toList();
      if (activeRecords.isEmpty) return 0;

      return activeRecords
          .map(getRecordDurationInSeconds)
          .reduce((a, b) => a > b ? a : b);
    }


  static int averageRecordDurationInSeconds(List<Record> records) {
    if (records.isEmpty) return 0;

    final totalSeconds = records.map((record) {
      final end = record.isActive
          ? DateTime.now()
          : record.desactivated ?? record.activated;

      return end.difference(record.activated).inSeconds;
    }).fold(0, (prev, curr) => prev + curr);

    return totalSeconds ~/ records.length;
  }
  static int longestRecordDurationInSeconds(List<Record> records) {
    if (records.isEmpty) return 0;

    return records.map((record) {
      final end = record.isActive
          ? DateTime.now()
          : record.desactivated ?? record.activated;

      return end.difference(record.activated).inSeconds;
    }).reduce((a, b) => a > b ? a : b);
  }
  static String formatDurationFromSeconds(int seconds) {
    final days = seconds ~/ (24 * 3600);
    seconds %= 24 * 3600;
    final hours = seconds ~/ 3600;
    seconds %= 3600;
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;

    return '${days}d ${hours}h ${minutes}m ${remainingSeconds}s';
  }
  static int getRecordDurationInSeconds(Record record) {
    final end = record.isActive
        ? DateTime.now()
        : record.desactivated ?? record.activated;

    return end.difference(record.activated).inSeconds;
  }














}