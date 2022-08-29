import 'dart:convert';

import 'package:baharudin_alarm/models/alarm_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataService {
  final SharedPreferences _prefs;
  final String _alarmKey = 'baharudin-alarm';

  DataService({required SharedPreferences sharedPreferences})
      : _prefs = sharedPreferences;

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
    return await _save(data);
  }

  List<AlarmModel> get() {
    final data = _getString(_alarmKey);
    final models = <AlarmModel>[];
    for (final key in data.keys) {
      if (data[key] != null) {
        models.add(AlarmModel.fromJson(data[key]));
      }
    }
    return models;
  }
}
