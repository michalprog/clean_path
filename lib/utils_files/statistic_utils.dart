import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '/data_types/record.dart';
import '/enums/enums.dart';
class StatisticUtils {

  static bool isActiveRecord(List<Record> records) {
    return records.any((record) => record.isActive);
  }
  static List<Record> getActiveRecords(List<Record> records) {
    return records.where((r) => r.isActive).toList();
  }
  static List<Record> getUnactiveRecords(List<Record> records) {
    return records.where((r) => !r.isActive).toList();
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


  static IconData getIconForAddiction(AddictionTypes type) {
    switch (type) {
      case AddictionTypes.fap:
        return Icons.self_improvement;
      case AddictionTypes.smoking:
        return Icons.smoking_rooms;
      case AddictionTypes.alcochol:
        return Icons.local_bar;
      case AddictionTypes.sweets:
        return Icons.cake;
      }
  }
  static double getRecordDurationInDays(Record record) {
    final seconds = getRecordDurationInSeconds(record);
    return seconds / (24 * 60 * 60);
  }
  static List<double> getAverageRecordsDuration(List<Record> records) {
    return records.map((r) => getRecordDurationInDays(r)).toList();
  }
  static List<FlSpot> convertRecordsToFlSpots(List<Record> records) {
    return List.generate(records.length, (index) {
      final record = records[index];
      final durationInDays = getRecordDurationInDays(record);
      return FlSpot(index.toDouble(), durationInDays);
    });
  }
  static Set<DateTime> getActiveDaysFromRecords(List<Record> records) {
    final activeDays = <DateTime>{};

    for (var record in records) {
      final start = DateTime(record.activated.year, record.activated.month, record.activated.day);
      final endRaw = record.isActive ? DateTime.now() : record.desactivated!;
      final end = DateTime(endRaw.year, endRaw.month, endRaw.day);

      DateTime current = start;
      // Dodaj dni do dnia *przed* końcem
      while (current.isBefore(end)) {
        activeDays.add(DateTime(current.year, current.month, current.day));
        current = current.add(const Duration(days: 1));
      }
    }

    return activeDays;
  }
  static Set<DateTime> getFailDaysFromRecords(List<Record> records) {
    final failDays = <DateTime>{};

    for (var record in records) {
      if (!record.isActive && record.desactivated != null) {
        final failDate = DateTime(
          record.desactivated!.year,
          record.desactivated!.month,
          record.desactivated!.day,
        );
        failDays.add(failDate);
      }
    }

    return failDays;
  }

}