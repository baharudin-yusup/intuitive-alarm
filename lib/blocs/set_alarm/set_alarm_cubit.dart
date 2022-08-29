import 'package:baharudin_alarm/blocs/main/main_cubit.dart';
import 'package:baharudin_alarm/models/alarm_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/math_util.dart';

part 'set_alarm_state.dart';

class SetAlarmCubit extends Cubit<SetAlarmState> {
  final MainCubit _mainCubit;
  final Offset _centerOffset;
  final MathUtil _mathUtil;

  SetAlarmCubit({
    DateTime? initialTime,
    required double clockDiagonal,
    required MathUtil mathUtil,
    required MainCubit mainCubit,
  })  : _mainCubit = mainCubit,
        _centerOffset = Offset(clockDiagonal / 2, clockDiagonal / 2),
        _mathUtil = mathUtil,
        super(SetAlarmState.initial(initialTime));

  void setHandStatus(PointerDownEvent event) {
    final offset = _convertedOffset(event.localPosition);
    final touchDegree = _mathUtil.offsetToClockDegree(offset);
    debugPrint('c: $touchDegree');

    final clockHourDegree = _mathUtil.clockHourToDegree(state.hour);
    final clockHourDistance =
        _mathUtil.clockDistance(clockHourDegree, touchDegree);

    final clockMinuteDegree = _mathUtil.clockMinuteToDegree(state.minute);
    final clockMinuteDistance =
        _mathUtil.clockDistance(clockMinuteDegree, touchDegree);

    final clockSecondDegree = _mathUtil.clockSecondToDegree(state.second);
    final clockSecondDistance =
        _mathUtil.clockDistance(clockSecondDegree, touchDegree);

    debugPrint(
        'h: $clockHourDistance | m: $clockMinuteDistance | s: $clockSecondDistance');

    if (clockHourDistance <= clockMinuteDistance &&
        clockHourDistance <= clockSecondDistance) {
      return emit(state.copyWith(status: SetAlarmStatus.setHour));
    }

    if (clockMinuteDistance <= clockHourDistance &&
        clockMinuteDistance <= clockSecondDistance) {
      return emit(state.copyWith(status: SetAlarmStatus.setMinute));
    }

    return emit(state.copyWith(status: SetAlarmStatus.setSecond));
  }

  void onTouchUp(PointerUpEvent event) {
    return emit(state.copyWith(status: SetAlarmStatus.initial));
  }

  void setTime(PointerMoveEvent event) {
    final rawOffset = event.localPosition;
    switch (state.status) {
      case SetAlarmStatus.initial:
        // TODO: Handle this case.
        break;
      case SetAlarmStatus.setHour:
        return setHour(rawOffset);
      case SetAlarmStatus.setMinute:
        return setMinute(rawOffset);
      case SetAlarmStatus.setSecond:
        return setSecond(rawOffset);
      case SetAlarmStatus.setAM:
        // TODO: Handle this case.
        break;
      case SetAlarmStatus.success:
        // TODO: Handle this case.
        break;
    }
  }

  void setHour(Offset rawOffset) {
    final offset = _convertedOffset(rawOffset);

    final degree = _mathUtil.offsetToClockDegree(offset);
    final hour = _mathUtil.degreeToClockHour(degree);

    if (state.isPM == false) {
      return emit(state.copyWith(hour: hour + 12));
    } else {
      return emit(state.copyWith(hour: hour));
    }
  }

  void setMinute(Offset rawOffset) {
    final offset = _convertedOffset(rawOffset);

    final degree = _mathUtil.offsetToClockDegree(offset);
    final minute = _mathUtil.degreeToClockMinute(degree);

    emit(state.copyWith(minute: minute));
  }

  void setSecond(Offset rawOffset) {
    final offset = _convertedOffset(rawOffset);

    final degree = _mathUtil.offsetToClockDegree(offset);
    final second = _mathUtil.degreeToClockSecond(degree);

    emit(state.copyWith(second: second));
  }

  void setAM(bool isPM) => emit(state.copyWith(isPM: isPM));

  Future<void> createAlarm() async {
    final currentTime = DateTime.now();
    late final DateTime alarmTime;

    if (currentTime.isAfter(state.rawTime)) {
      alarmTime = state.rawTime.add(const Duration(days: 1));
    } else {
      alarmTime = state.rawTime;
    }

    final model = AlarmModel.fromBloc(time: alarmTime);
    return await _mainCubit.createAlarm(model);
  }

  Offset _convertedOffset(Offset rawOffset) =>
      Offset(rawOffset.dx - _centerOffset.dx, rawOffset.dy - _centerOffset.dy);
}
