part of 'statistic_cubit.dart';

class StatisticState extends Equatable {
  final List<AlarmModel> alarms;

  const StatisticState({
    required this.alarms,
  });

  factory StatisticState.initial() {
    return const StatisticState(alarms: []);
  }

  StatisticState copyWith({
    List<AlarmModel>? alarms,
  }) {
    return StatisticState(
      alarms: alarms ?? this.alarms,
    );
  }

  @override
  List<Object?> get props => [
        alarms,
      ];
}
