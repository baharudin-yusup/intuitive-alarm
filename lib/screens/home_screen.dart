import 'package:baharudin_alarm/blocs/home/home_cubit.dart';
import 'package:baharudin_alarm/widgets/analog_clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final clockDiagonal = width * 0.8;
    return SizedBox(
      width: width,
      height: height,
      child: BlocProvider<HomeCubit>(
        create: (context) => HomeCubit(),
        child: BlocBuilder<HomeCubit, DateTime>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: height * 0.05),
                      child: _TextClock(time: state),
                    ),
                    AnalogClock(
                      diagonal: clockDiagonal,
                      time: state,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _TextClock extends StatelessWidget {
  final DateTime time;

  const _TextClock({Key? key, required this.time}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.bodyLarge?.copyWith(fontSize: 30);
    return Column(
      children: [
        show(style),
      ],
    );
  }

  Widget show(TextStyle? style) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    final second = time.second.toString().padLeft(2, '0');
    return Text('$hour:$minute:$second', style: style);
  }
}
