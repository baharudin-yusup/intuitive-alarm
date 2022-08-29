import 'dart:async';
import 'package:baharudin_alarm/models/alarm_model.dart';
import 'package:baharudin_alarm/services/data_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final DataService _dataService;
  late final Timer timer;

  HomeCubit({
    required DataService dataService,
  })  : _dataService = dataService,
        super(HomeState.initial()) {
    _dataService.upcomingAlarm.last.then((mainState) {
      if (!isClosed) {
        emit(state.copyWith(upcomingAlarm: mainState));
      }
    });
    _dataService.upcomingAlarm.listen((mainState) {
      if (!isClosed) {
        emit(state.copyWith(upcomingAlarm: mainState));
      }
    });

    timer = Timer.periodic(const Duration(milliseconds: 50), _updateTime);
  }

  @override
  Future<void> close() {
    timer.cancel();
    return super.close();
  }

  void _updateTime(Timer timer) {
    emit(
      state.copyWith(
        currentTime: DateTime.now(),
      ),
    );
  }
}
