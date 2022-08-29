part of 'set_alarm_cubit.dart';

enum SetAlarmStatus {
  initial,
  setHour,
  setMinute,
  setSecond,
  setAM,
  success,
}

@immutable
class SetAlarmState extends Equatable {
  final SetAlarmStatus status;
  final int hour;
  final int minute;
  final int second;
  final bool isPM;

  const SetAlarmState({
    required this.hour,
    required this.minute,
    required this.second,
    required this.isPM,
    required this.status,
  });

  factory SetAlarmState.initial([DateTime? time]) {
    final initialTime = time ?? DateTime.now();
    final int hour = initialTime.hour;
    final int minute = initialTime.minute;
    final int second = initialTime.second;
    final bool isPM = initialTime.hour >= 12;

    return SetAlarmState(
        hour: hour,
        minute: minute,
        second: second,
        isPM: isPM,
        status: SetAlarmStatus.initial);
  }

  SetAlarmState copyWith(
      {int? hour,
      int? minute,
      int? second,
      bool? isPM,
      SetAlarmStatus? status}) {
    return SetAlarmState(
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      second: second ?? this.second,
      isPM: isPM ?? this.isPM,
      status: status ?? this.status,
    );
  }

  DateTime get rawTime {
    final currentDate = DateTime.now();
    final formattedHour = isPM ? hour + 12 : hour;
    return DateTime(
      currentDate.year,
      currentDate.month,
      currentDate.day,
      formattedHour,
      minute,
      second,
      currentDate.millisecond,
      currentDate.microsecond,
    );
  }

  @override
  List<Object?> get props => [status, isPM, hour, minute, second];
}
