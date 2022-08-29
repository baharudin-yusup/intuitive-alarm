import 'package:baharudin_alarm/blocs/main/main_cubit.dart';
import 'package:baharudin_alarm/screens/main_screen.dart';
import 'package:baharudin_alarm/services/alarm_service.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'services/data_service.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dataService = DataService(
    sharedPreferences: await SharedPreferences.getInstance(),
  );
  dataService.init();

  final alarmService = AlarmService(
    dataService: dataService,
    localNotificationsPlugin: FlutterLocalNotificationsPlugin(),
    deviceInfo: DeviceInfoPlugin(),
  );
  await alarmService.init();
  await alarmService.requestPermission();

  runApp(
    BaharudinAlarm(
      alarmService: alarmService,
      dataService: dataService,
    ),
  );
}

class BaharudinAlarm extends StatelessWidget {
  final AlarmService _alarmService;
  final DataService _dataService;

  const BaharudinAlarm({
    Key? key,
    required AlarmService alarmService,
    required DataService dataService,
  })  : _alarmService = alarmService,
        _dataService = dataService,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MainCubit>(
          create: (_) => MainCubit(
            alarmService: _alarmService,
            dataService: _dataService,
          ),
        ),
      ],
      child: DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
          ColorScheme lightColorScheme;
          ColorScheme darkColorScheme;

          if (lightDynamic != null && darkDynamic != null) {
            lightColorScheme = lightDynamic.harmonized();
            darkColorScheme = darkDynamic.harmonized();
          } else {
            lightColorScheme = ColorScheme.fromSeed(
              seedColor: Colors.green,
            );
            darkColorScheme = ColorScheme.fromSeed(
              seedColor: Colors.green,
              brightness: Brightness.dark,
            );
          }

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Baharudin Alarm',
            theme: ThemeData(colorScheme: lightColorScheme),
            darkTheme: ThemeData(colorScheme: darkColorScheme),
            home: const MainScreen(),
          );
        },
      ),
    );
  }
}
