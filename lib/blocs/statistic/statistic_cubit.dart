import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../models/alarm_model.dart';
import '../main/main_cubit.dart';

part 'statistic_state.dart';

class StatisticCubit extends Cubit<StatisticState> {
  final MainCubit _mainCubit;

  StatisticCubit({required MainCubit mainCubit})
      : _mainCubit = mainCubit,
        super(StatisticState.initial()) {
    final alarms = _mainCubit.getAlarms();

    emit(
      state.copyWith(
        alarms: alarms,
      ),
    );
  }

  List<AlarmModel> get activeAlarms {
    final alarms = <AlarmModel>[];

    for (final alarm in state.alarms) {
      if (alarm.isActive) {
        alarms.add(alarm);
      }
    }

    return alarms;
  }

  List<AlarmModel> get currentDayAlarms {
    final alarms = <AlarmModel>[];

    final currentTime = DateTime.now();
    for (final rawAlarm in state.alarms) {
      final alarmTime = rawAlarm.createdAt;
      if (alarmTime.year == currentTime.year &&
          alarmTime.month == currentTime.month &&
          alarmTime.day == currentTime.day) {
        alarms.add(rawAlarm);
      }
    }

    return alarms;
  }

  List<ChartSeries<AlarmModel, String>> get seriesList {
    return [
      BarSeries<AlarmModel, String>(
        dataSource: state.alarms,
        xValueMapper: (datum, index) => datum.barTitle,
        yValueMapper: (datum, index) => datum.waitingTime,
        enableTooltip: true,
        dataLabelSettings: const DataLabelSettings(isVisible: true),
      )
    ];
  }
}
