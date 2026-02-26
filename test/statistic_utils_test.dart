import 'package:clean_path/data_types/record.dart';
import 'package:clean_path/enums/enums.dart';
import 'package:clean_path/utils_files/statistic_utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime.now();
  final records = <Record>[
    Record(
      1,
      AddictionTypes.fap,
      true,
      now.subtract(const Duration(days: 3, hours: 2)),
    ),
    Record(
      2,
      AddictionTypes.smoking,
      false,
      now.subtract(const Duration(days: 5)),
      desactivated: now.subtract(const Duration(days: 2)),
    ),
    Record(
      3,
      AddictionTypes.fap,
      false,
      now.subtract(const Duration(days: 1)),
      desactivated: now.subtract(const Duration(hours: 12)),
    ),
  ];

  test('filters records by active status and type', () {
    expect(StatisticUtils.isActiveRecord(records), true);
    expect(StatisticUtils.getActiveRecords(records).length, 1);
    expect(StatisticUtils.getUnactiveRecords(records).length, 2);
    expect(
      StatisticUtils.getRecordsByType(records, AddictionTypes.fap).length,
      2,
    );
  });

  test('returns icon per addiction type', () {
    expect(StatisticUtils.getIconForAddiction(AddictionTypes.fap), Icons.self_improvement);
    expect(StatisticUtils.getIconForAddiction(AddictionTypes.smoking), Icons.smoking_rooms);
    expect(StatisticUtils.getIconForAddiction(AddictionTypes.alcochol), Icons.local_bar);
    expect(StatisticUtils.getIconForAddiction(AddictionTypes.sweets), Icons.cake);
  });

  test('formatDurationFromSeconds formats mixed durations', () {
    expect(StatisticUtils.formatDurationFromSeconds(90061), '1d 1h 1m 1s');
  });

  test('duration helpers return expected values', () {
    final inactive = records[1];
    final inactiveSeconds = StatisticUtils.getRecordDurationInSeconds(inactive);
    expect(inactiveSeconds, const Duration(days: 3).inSeconds);

    final activeSeconds = StatisticUtils.getActiveRecordDuration(records);
    expect(activeSeconds, greaterThanOrEqualTo(const Duration(days: 3, hours: 1).inSeconds));
    expect(activeSeconds, lessThanOrEqualTo(const Duration(days: 3, hours: 3).inSeconds));

    final average = StatisticUtils.averageRecordDurationInSeconds(records);
    final longest = StatisticUtils.longestRecordDurationInSeconds(records);

    expect(longest, greaterThanOrEqualTo(average));
    expect(longest, greaterThan(0));
    expect(average, greaterThan(0));
  });

  test('converts duration to days and fl spots', () {
    final dayRecord = Record(
      99,
      AddictionTypes.sweets,
      false,
      now.subtract(const Duration(days: 2)),
      desactivated: now.subtract(const Duration(days: 1)),
    );

    expect(StatisticUtils.getRecordDurationInDays(dayRecord), closeTo(1.0, 0.001));

    final averages = StatisticUtils.getAverageRecordsDuration([dayRecord]);
    expect(averages, hasLength(1));
    expect(averages.first, closeTo(1.0, 0.001));

    final spots = StatisticUtils.convertRecordsToFlSpots([dayRecord]);
    expect(spots, hasLength(1));
    expect(spots.first, isA<FlSpot>());
    expect(spots.first.x, 0.0);
    expect(spots.first.y, closeTo(1.0, 0.001));
  });

  test('extracts active and fail days from records', () {
    final day1 = DateTime(2026, 1, 1, 8);
    final day4 = DateTime(2026, 1, 4, 10);
    final day6 = DateTime(2026, 1, 6, 9);

    final sample = <Record>[
      Record(1, AddictionTypes.fap, false, day1, desactivated: day4),
      Record(2, AddictionTypes.smoking, false, day4, desactivated: day6),
    ];

    final activeDays = StatisticUtils.getActiveDaysFromRecords(sample);
    expect(activeDays, contains(DateTime(2026, 1, 1)));
    expect(activeDays, contains(DateTime(2026, 1, 2)));
    expect(activeDays, contains(DateTime(2026, 1, 3)));
    expect(activeDays, contains(DateTime(2026, 1, 4)));
    expect(activeDays, contains(DateTime(2026, 1, 5)));
    expect(activeDays, isNot(contains(DateTime(2026, 1, 6))));

    final failDays = StatisticUtils.getFailDaysFromRecords(sample);
    expect(failDays.length, 2);
    expect(failDays, contains(DateTime(2026, 1, 4)));
    expect(failDays, contains(DateTime(2026, 1, 6)));
  });
}