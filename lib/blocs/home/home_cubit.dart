import 'dart:async';
import 'package:baharudin_alarm/blocs/main/main_cubit.dart';
import 'package:baharudin_alarm/models/alarm_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final MainCubit _mainCubit;
  late final Timer timer;

  HomeCubit({required MainCubit mainCubit})
      : _mainCubit = mainCubit,
        super(HomeState.initial()) {
    timer = Timer.periodic(const Duration(milliseconds: 50), _updateTime);
    emit(state.copyWith(upcomingAlarm: _mainCubit.upcomingAlarm));
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
