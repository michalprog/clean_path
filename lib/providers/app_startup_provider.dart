import 'package:clean_path/main/notification_service.dart';
import 'package:clean_path/providers/account_provider.dart';
import 'package:flutter/foundation.dart';

class AppStartupProvider extends ChangeNotifier {
  AppStartupProvider({
    required AccountProvider accountProvider,
    required NotificationService notificationService,
  }) : _accountProvider = accountProvider,
        _notificationService = notificationService;

  final AccountProvider _accountProvider;
  final NotificationService _notificationService;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await _accountProvider.loadUser();
      await _notificationService.scheduleNotificationsFromTomorrow();
      _isInitialized = true;
      notifyListeners();
    } catch (error, stackTrace) {
      debugPrint('Startup initialization error: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }
}