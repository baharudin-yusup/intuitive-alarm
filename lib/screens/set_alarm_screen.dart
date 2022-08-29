import 'package:baharudin_alarm/utils/math_util.dart';
import 'package:baharudin_alarm/widgets/analog_clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/main/main_cubit.dart';
import '../blocs/set_alarm/set_alarm_cubit.dart';
import '../widgets/text_clock.dart';

class SetAlarmScreen extends StatelessWidget {
  const SetAlarmScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final clockDiagonal = width * 0.8;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        vertical: height * 0.05,
        horizontal: width * 0.05,
      ),
      child: SafeArea(
        child: BlocProvider<SetAlarmCubit>(
          create: (context) => SetAlarmCubit(
            mainCubit: context.read<MainCubit>(),
            mathUtil: MathUtil(),
            clockDiagonal: clockDiagonal,
          ),
          child: BlocBuilder<SetAlarmCubit, SetAlarmState>(
            builder: (context, state) {
              final setAlarmCubit = context.read<SetAlarmCubit>();
              return Column(
                children: [
                  SizedBox(
                    width: clockDiagonal,
                    height: clockDiagonal,
                    child: Listener(
                      onPointerDown: setAlarmCubit.setHandStatus,
                      onPointerMove: setAlarmCubit.setTime,
                      onPointerUp: setAlarmCubit.onTouchUp,
                      child: AnalogClock(
                        diagonal: clockDiagonal,
                        time: state.rawTime,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: height * 0.05),
                    child: Column(
                      children: [
                        Text(
                          'Set Alarm',
                          style: textTheme.displaySmall,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: width * 0.05, bottom: width * 0.1),
                          child: Row(
                            children: [
                              TextClock(
                                  time: state.rawTime, use12HourFormat: true),
                              const Spacer(),
                              Text(
                                'AM',
                                style: textTheme.titleLarge,
                              ),
                              Switch.adaptive(
                                  inactiveThumbColor:
                                      theme.toggleableActiveColor,
                                  inactiveTrackColor: theme
                                      .toggleableActiveColor
                                      .withOpacity(0.5),
                                  activeColor: theme.toggleableActiveColor,
                                  activeTrackColor: theme.toggleableActiveColor
                                      .withOpacity(0.5),
                                  value: state.isPM,
                                  onChanged: setAlarmCubit.setAM),
                              Text('PM', style: textTheme.titleLarge),
                            ],
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              setAlarmCubit.createAlarm().then((_) {
                                const snackBar = SnackBar(
                                  content: Text('Set Alarm Success!'),
                                );

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              });
                            },
                            child: const Text('Set Alarm')),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
