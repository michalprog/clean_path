import 'package:flutter/material.dart';

import '../data_types/record.dart';
import '../sqlflite/record_dao.dart';

/// Provides minimal database access shared by timer widget flows.
class DatabaseProvider extends ChangeNotifier {
  final RecordDao _recordDao = RecordDao();

  /// Returns all active records for timer usage.
  Future<List<Record>> getActiveRecords() => _recordDao.getAllActive();
}