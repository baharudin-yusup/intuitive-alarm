part of 'home_cubit.dart';

class HomeState extends Equatable {
  final DateTime currentTime;
  final AlarmModel? upcomingAlarm;

  const HomeState({required this.currentTime, this.upcomingAlarm});

  factory HomeState.initial() {
    return HomeState(
      currentTime: DateTime.now(),
    );
  }

  HomeState copyWith({
    DateTime? currentTime,
    AlarmModel? upcomingAlarm,
  }) {
    return HomeState(
      currentTime: currentTime ?? this.currentTime,
      upcomingAlarm: upcomingAlarm ?? this.upcomingAlarm,
    );
  }

  @override
  List<Object?> get props => [
        currentTime,
        upcomingAlarm,
      ];
}
