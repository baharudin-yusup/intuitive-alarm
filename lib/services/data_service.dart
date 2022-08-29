import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:baharudin_alarm/models/alarm_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataService {
  final SharedPreferences _prefs;
  final String _alarmKey = 'baharudin-alarm';

  DataService({required SharedPreferences sharedPreferences})
      : _prefs = sharedPreferences;

  void init() {
    final upcomingAlarm = _checkUpcomingAlarm;
    if (upcomingAlarm != null) {
      debugPrint('init upcoming alarm: ${upcomingAlarm.createdAt}');
      _upcomingAlarmController.sink.add(upcomingAlarm);
    } else {
      debugPrint('no upcoming alarm');
    }
  }

  Map<String, dynamic> _getString(String key) {
    final String raw = _prefs.getString(_alarmKey) ?? '{}';
    return jsonDecode(raw);
  }

  Future<bool> _save(Map data) async {
    return _prefs.setString(_alarmKey, jsonEncode(data));
  }

  Future<bool> remove(String id) async {
    final data = _getString(_alarmKey);
    data[id] = null;
    return await _save(data);
  }

  Future<bool> add(AlarmModel model) async {
    final data = _getString(_alarmKey);
    data[model.id] = model.toJson();
    await _save(data);
    final upcomingAlarm = _checkUpcomingAlarm;
    if (upcomingAlarm != null) {
      _upcomingAlarmController.sink.add(upcomingAlarm);
    }

    return true;
  }

  AlarmModel? getSpecificAlarm(String id) {
    final alarms = getAllAlarms();

    try {
      final validAlarm = alarms.firstWhere((alarm) => alarm.id == id);
      return validAlarm;
    } catch (error) {
      return null;
    }
  }

  List<AlarmModel> getAllAlarms() {
    final data = _getString(_alarmKey);
    final models = <AlarmModel>[];
    for (final key in data.keys) {
      if (data[key] != null) {
        models.add(AlarmModel.fromJson(data[key]));
      }
    }
    models.sort(
      (a, b) => a.createdAt.compareTo(b.createdAt),
    );
    return models;
  }

  AlarmModel? get _checkUpcomingAlarm {
    final alarms = getAllAlarms();
    if (alarms.isEmpty) {
      return null;
    }
    final currentTime = DateTime.now();
    for (final alarm in alarms) {
      if (alarm.createdAt.isAfter(currentTime)) {
        return alarm;
      }
    }
    return null;
  }

  List<AlarmModel> getCurrentDayAlarms() {
    final rawAlarms = getAllAlarms();
    final currentTime = DateTime.now();
    final currentDayAlarms = <AlarmModel>[];

    for (final rawAlarm in rawAlarms) {
      final alarmTime = rawAlarm.createdAt;
      if (alarmTime.year == currentTime.year &&
          alarmTime.month == currentTime.month &&
          alarmTime.day == currentTime.day) {
        currentDayAlarms.add(rawAlarm);
      }
    }

    return currentDayAlarms;
  }

  final _upcomingAlarmController = BehaviorSubject<AlarmModel>();

  Stream<AlarmModel> get upcomingAlarm {
    return _upcomingAlarmController.stream;
  }
}
