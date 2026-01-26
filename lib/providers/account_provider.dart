import 'package:flutter/material.dart';

import '/data_types/leveling_service.dart';
import '/data_types/user.dart';
import '/data_types/leveling_result.dart';
import '/enums/enums.dart';

import '/main/service_locator.dart';
import '/sqlflite/account_dao.dart';

class AccountProvider extends ChangeNotifier {
  final AccountDao _accountDao = AccountDao();
  final LevelingService _levelingService = getIt<LevelingService>();
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;

  Future<void> loadUser() async {
    _isLoading = true;
    notifyListeners();
    _user = await _accountDao.getUser();
    _isLoading = false;
    notifyListeners();
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