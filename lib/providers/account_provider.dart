import 'package:flutter/material.dart';

import '/data_types/user.dart';
import '/sqlflite/account_dao.dart';

class AccountProvider extends ChangeNotifier {
  final AccountDao _accountDao = AccountDao();
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

  Future<void> updateUser(User user) async {
    await _accountDao.upsertUser(user);
    _user = user;
    notifyListeners();
  }
}