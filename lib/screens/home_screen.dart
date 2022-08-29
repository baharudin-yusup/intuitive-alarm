import 'package:baharudin_alarm/blocs/home/home_cubit.dart';
import 'package:baharudin_alarm/models/alarm_model.dart';
import 'package:baharudin_alarm/widgets/analog_clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/main/main_cubit.dart';
import '../widgets/text_clock.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final clockDiagonal = width * 0.8;

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final mainCubit = context.read<MainCubit>();
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        vertical: height * 0.05,
        horizontal: width * 0.05,
      ),
      child: SafeArea(
        child: BlocProvider<HomeCubit>(
          create: (context) =>
              HomeCubit(dataService: mainCubit.dataService),
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              return SingleChildScrollView(
                child: SafeArea(
                  child: Column(
                    children: [
                      Center(
                        child: AnalogClock(
                          diagonal: clockDiagonal,
                          time: state.currentTime,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: height * 0.05),
                        child: Column(
                          children: [
                            Text(
                              'Current Time',
                              style: textTheme.displaySmall,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: width * 0.05,
                              ),
                              child: TextClock(time: state.currentTime),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: height * 0.05),
                        child: Column(
                          children: [
                            Text(
                              'Upcoming Alarm',
                              style: textTheme.displaySmall,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: width * 0.05,
                              ),
                              child: _showUpcomingAlarm(
                                  state.upcomingAlarm, context),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _showUpcomingAlarm(AlarmModel? upcomingAlarm, BuildContext context) {
    final textStyle = Theme.of(context).textTheme.titleLarge;
    if (upcomingAlarm == null) {
      return Text(
        'No upcoming alarm :)',
        style: textStyle,
      );
    }
    return TextClock(
      time: upcomingAlarm.createdAt,
      showFullTitle: true,
    );
  }
}
