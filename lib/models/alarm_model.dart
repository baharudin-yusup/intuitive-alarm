import 'package:uuid/uuid.dart';

class AlarmModel {
  final String id;
  final DateTime time;

  AlarmModel({
    required this.time,
    required this.id,
  });

  factory AlarmModel.fromBloc({required DateTime time}) {
    final id = const Uuid().v4();
    return AlarmModel(
      id: id,
      time: time,
    );
  }

  factory AlarmModel.fromJson(Map<String, dynamic> json) {
    return AlarmModel(
      time: DateTime.parse(json['time']),
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'time': time.toIso8601String(),
    };
  }
}
