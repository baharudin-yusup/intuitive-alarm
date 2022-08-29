import 'package:baharudin_alarm/blocs/main/main_cubit.dart';
import 'package:baharudin_alarm/screens/home_screen.dart';
import 'package:baharudin_alarm/screens/statistic_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'set_alarm_screen.dart';

class MainScreen extends StatelessWidget {
  static const route = '/main';
  static const notificationRoute = '/notification';

  final int initialScreen;
  final String? initialAlarmId;

  const MainScreen({Key? key, this.initialScreen = 0, this.initialAlarmId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final mainCubit = context.read<MainCubit>();
    mainCubit.navigateTo(initialScreen);
    return BlocBuilder<MainCubit, MainState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: colorScheme.background,
          bottomNavigationBar: NavigationBar(
            selectedIndex: state.screenIndex,
            onDestinationSelected: mainCubit.navigateTo,
            destinations: const <NavigationDestination>[
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.alarm_add_outlined),
                label: 'Set Alarm',
              ),
              NavigationDestination(
                icon: Icon(Icons.list_alt_outlined),
                label: 'Status',
              ),
            ],
          ),
          body: _getScreen(state.screenIndex),
        );
      },
    );
  }

  Widget _getScreen(int screen) {
    switch (screen) {
      case 0:
        return const HomeScreen();
      case 1:
        return const SetAlarmScreen();
      case 2:
        return const StatisticScreen();
      default:
        return const HomeScreen();
    }
  }
}
