import 'dart:io';

import 'package:baharudin_alarm/models/alarm_model.dart';
import 'package:baharudin_alarm/screens/main_screen.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

import 'navigator_service.dart';

class AlarmService {
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin;
  final DeviceInfoPlugin _deviceInfo;
  final NavigatorService _navigatorService;

  AlarmService({
    required NavigatorService navigatorService,
    required FlutterLocalNotificationsPlugin localNotificationsPlugin,
    required DeviceInfoPlugin deviceInfo,
  })  : _deviceInfo = deviceInfo,
        _localNotificationsPlugin = localNotificationsPlugin,
        _navigatorService = navigatorService;

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
        _navigatorService.pushNamed(MainScreen.notificationRoute, args: id);
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
    debugPrint('set alarm! at ${model.time}');
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
      'Alarm coming!',
      tz.TZDateTime.from(model.time, tz.local),
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: model.id,
    );
  }
}
