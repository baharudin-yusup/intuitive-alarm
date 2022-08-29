import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/alarm_model.dart';
import '../../services/alarm_service.dart';
import '../../services/data_service.dart';
import '../../services/navigator_service.dart';

part 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  final AlarmService _alarmService;
  final DataService _dataService;

  MainCubit({
    required AlarmService alarmService,
    required NavigatorService navigatorService,
    required DataService dataService,
  })  : _alarmService = alarmService,
        _dataService = dataService,
        super(MainState.initial());

  Future<bool?> requestPermission() async {
    return _alarmService.requestPermission();
  }

  Future<void> createAlarm(AlarmModel model) async {
    final successSaveData = await _dataService.add(model);
    if (successSaveData) {
      await _alarmService.createAlarm(model);
    }
  }

  void navigateTo(int screenIndex) {
    return emit(state.copyWith(screenIndex: screenIndex));
  }

  List<AlarmModel> getAlarms() {
    return _dataService.getAllAlarms();
  }

  List<AlarmModel> getCurrentDayAlarms() {
    return _dataService.getCurrentDayAlarms();
  }

  AlarmModel? get upcomingAlarm => _dataService.upcomingAlarm;
}
