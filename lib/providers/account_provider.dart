import 'package:flutter/material.dart';

import '/data_types/leveling_service.dart';
import '/data_types/user.dart';
import '/data_types/leveling_result.dart';
import '/enums/enums.dart';

import '/main/service_locator.dart';
import '/sqlflite/account_dao.dart';
import '/sqlflite/daily_login_dao.dart';

class AccountProvider extends ChangeNotifier {
  final AccountDao _accountDao = AccountDao();
  final DailyLoginDao _dailyLoginDao = DailyLoginDao();
  final LevelingService _levelingService = getIt<LevelingService>();
  User? _user;
  bool _isLoading = false;
  bool _shouldShowDailyWelcome = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get shouldShowDailyWelcome => _shouldShowDailyWelcome;

  Future<void> loadUser() async {
    _isLoading = true;
    notifyListeners();
    _user = await _accountDao.getUser();
    final username = _user?.username;
    if (username != null && username.isNotEmpty) {
      _shouldShowDailyWelcome = await _dailyLoginDao.ensureTodayLoginSaved(
        username,
      );
    }
    _isLoading = false;
    notifyListeners();
  }

  void consumeDailyWelcomeFlag() {
    _shouldShowDailyWelcome = false;
  }

  Future<void> updateUser(User user, {String? previousUsername}) async {
    await _accountDao.upsertUser(user, previousUsername: previousUsername);
    _user = user;
    notifyListeners();
  }

  Future<LevelingResult?> applyLevelingAction(LevelingAction action) async {
    final currentUser = _user;
    if (currentUser == null) {
      return null;
    }
    final result = _levelingService.applyAction(
      user: currentUser,
      action: action,
    );
    await updateUser(result.user);
    return result;
  }
}