import 'dart:io';

import 'package:baharudin_alarm/models/alarm_model.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

import 'data_service.dart';

class AlarmService {
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin;
  final BehaviorSubject<String> _payloadStreamController;
  final DataService _dataService;

  Stream<String> get notifications => _payloadStreamController.stream;

  AlarmService({
    required FlutterLocalNotificationsPlugin localNotificationsPlugin,
    required DeviceInfoPlugin deviceInfo,
    required DataService dataService,
  })  : _localNotificationsPlugin = localNotificationsPlugin,
        _dataService = dataService,
        _payloadStreamController = BehaviorSubject<String>();

  Future<void> _configureLocalTimeZone() async {
    if (kIsWeb || Platform.isLinux) {
      return;
    }
    tz.initializeTimeZones();
  }

  Future<void> init() async {
    await _configureLocalTimeZone();
    final notificationAppLaunchDetails =
        await _localNotificationsPlugin.getNotificationAppLaunchDetails();

    var initializationSettingsAndroid =
        const AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {
        await _handlePayload(payload);
        if (payload != null) {
          _payloadStreamController.sink.add(payload);
        }
      },
    );
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await _localNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (payload) async {
        debugPrint('onSelectNotification: $payload');
        await _handlePayload(payload);
        if (payload != null) {
          _payloadStreamController.sink.add(payload);
        }
      },
    );

    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      final payload = notificationAppLaunchDetails!.payload;
      await _handlePayload(payload);
      if (payload != null) {
        _payloadStreamController.sink.add(payload);
      }
    }
  }

  Future<void> _handlePayload(String? payload) async {
    debugPrint('handle payload: $payload');
    if (payload != null) {
      final alarm = _dataService.getSpecificAlarm(payload);
      if (alarm != null) {
        await _dataService.add(
          alarm.copyWith(
            openedAt: DateTime.now(),
          ),
        );
      }
    }
  }

  Future<bool?> requestPermission() async {
    if (Platform.isAndroid) {
      await Permission.ignoreBatteryOptimizations.status;
    }

    return await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
  }

  Future<void> createAlarm(AlarmModel model) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'baharudin_alarm',
      'baharudin_alarm',
      channelDescription: 'Baharudin Alarm',
    );

    var iOSPlatformChannelSpecifics = const IOSNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    var notificationDetails = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _localNotificationsPlugin.zonedSchedule(
      0,
      'Baharudin Alarm',
      'Alarm is coming! (${model.title})',
      tz.TZDateTime.from(model.createdAt, tz.local),
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: model.id,
    );
  }
}
