part of 'main_cubit.dart';

class MainState extends Equatable {
  final int screenIndex;
  final AlarmModel? upcomingAlarm;

  const MainState({required this.screenIndex, this.upcomingAlarm});

  factory MainState.initial() => const MainState(screenIndex: 0);

  MainState copyWith({
    int? screenIndex,
    AlarmModel? upcomingAlarm,
  }) {
    return MainState(
        screenIndex: screenIndex ?? this.screenIndex,
        upcomingAlarm: upcomingAlarm ?? this.upcomingAlarm);
  }

  @override
  List<Object?> get props => [
        screenIndex,
        upcomingAlarm,
      ];
}
