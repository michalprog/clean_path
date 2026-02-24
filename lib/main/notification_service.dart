import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService(this._notificationsPlugin);

  final FlutterLocalNotificationsPlugin _notificationsPlugin;

  static const int _notificationStartId = 2000;
  static const int _daysToScheduleAhead = 120;
  static const List<String> _motivationalMessages = [
    'Jeden świadomy wybór dziś to ogromny krok ku wolności jutro.',
    'Masz siłę powiedzieć „nie” nawykom, które Cię osłabiają.',
    'Twój mózg się regeneruje – każdy dzień ma znaczenie.',
    'Nie musisz być idealny. Wystarczy, że dziś będziesz konsekwentny.',
    'Walka z uzależnieniem to trening charakteru. Trwasz – wygrywasz.',
    'Gdy pojawia się pokusa, przypomnij sobie, kim chcesz się stać.',
    'Twoja przyszłość jest ważniejsza niż chwilowa ulga.',
    'Każdy czysty dzień buduje Twoją pewność siebie.',
    'Zamiast wracać do nawyku, wybierz siebie i swoje cele.',
    'To tylko moment – przetrwaj go, a jutro podziękujesz sobie.',
  ];

  final Random _random = Random();
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    const androidSettings = AndroidInitializationSettings('@mipmap/launcher_icon');
    const iosSettings = DarwinInitializationSettings();

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(settings: initSettings);
    await _requestPermissions();

    tz.initializeTimeZones();
    final timezoneInfo = await FlutterTimezone.getLocalTimezone();
    final timezoneName = _extractTimezoneName(timezoneInfo);
    tz.setLocalLocation(tz.getLocation(timezoneName));

    _isInitialized = true;
  }

  Future<void> scheduleNotificationsFromTomorrow() async {
    await initialize();
    await _notificationsPlugin.cancelAll();

    for (var i = 0; i < _daysToScheduleAhead; i++) {
      final scheduledDate = _buildNext20PmDate(i + 1);
      final message = _motivationalMessages[_random.nextInt(_motivationalMessages.length)];

      await _notificationsPlugin.zonedSchedule(
        id: _notificationStartId + i,
        title: 'Czas zadbać o siebie',
        body: message,
        scheduledDate: scheduledDate,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'clean_path_daily_motivation',
            'Daily motivation',
            channelDescription: 'Motywujące przypomnienia o walce z uzależnieniem',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    }
  }

  tz.TZDateTime _buildNext20PmDate(int daysToAdd) {
    final now = tz.TZDateTime.now(tz.local);
    return tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day + daysToAdd,
      20,
    );
  }

  Future<void> _requestPermissions() async {
    final androidImplementation =
    _notificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidImplementation?.requestNotificationsPermission();

    final iosImplementation =
    _notificationsPlugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    await iosImplementation?.requestPermissions(alert: true, badge: true, sound: true);
  }

  String _extractTimezoneName(Object timezoneInfo) {
    if (timezoneInfo is String) {
      return timezoneInfo;
    }

    final dynamic dynamicValue = timezoneInfo;
    final dynamic identifier = dynamicValue.identifier;
    if (identifier is String && identifier.isNotEmpty) {
      return identifier;
    }

    final dynamic name = dynamicValue.name;
    if (name is String && name.isNotEmpty) {
      return name;
    }

    return 'UTC';
  }
}