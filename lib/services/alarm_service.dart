import 'dart:io';

import 'package:baharudin_alarm/models/alarm_model.dart';
import 'package:baharudin_alarm/screens/main_screen.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

import 'data_service.dart';
import 'navigator_service.dart';

class AlarmService {
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin;
  final DeviceInfoPlugin _deviceInfo;
  final NavigatorService _navigatorService;
  final DataService _dataService;

  AlarmService({
    required NavigatorService navigatorService,
    required FlutterLocalNotificationsPlugin localNotificationsPlugin,
    required DeviceInfoPlugin deviceInfo,
    required DataService dataService,
  })  : _deviceInfo = deviceInfo,
        _localNotificationsPlugin = localNotificationsPlugin,
        _navigatorService = navigatorService,
        _dataService = dataService;

  Future<void> _configureLocalTimeZone() async {
    if (kIsWeb || Platform.isLinux) {
      return;
    }
    tz.initializeTimeZones();
  }

  Future<void> init() async {
    await _configureLocalTimeZone();
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {
        debugPrint('id: $id | title: $title | body: $body | payload: $payload');
      },
    );
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await _localNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? id) async {
      if (id != null) {
        final alarm = _dataService.getSpecificAlarm(id);

        if (alarm != null) {
          await _dataService.add(alarm.copyWith(openedAt: DateTime.now()));
        }
        _navigatorService.pushNamed(MainScreen.notificationRoute);
      }
    });
  }

  Future<bool?> requestPermission() async {
    if (!Platform.isAndroid) {
      return null;
    }
    final androidSdk = (await _deviceInfo.androidInfo).version.sdkInt ?? 0;
    if (androidSdk < 33) {
      return null;
    }

    return await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
  }

  Future<void> createAlarm(AlarmModel model) async {
    debugPrint('set alarm! at ${model.createdAt}');
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'baharudin_alarm',
      'baharudin_alarm',
      channelDescription: 'Baharudin Alarm',
      icon: 'app_icon',
    );

    var iOSPlatformChannelSpecifics = const IOSNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _localNotificationsPlugin.zonedSchedule(
      0,
      'Baharudin Alarm',
      'Alarm is coming! (${model.title})',
      tz.TZDateTime.from(model.createdAt, tz.local),
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: model.id,
    );
  }


}
