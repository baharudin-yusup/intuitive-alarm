import 'package:baharudin_alarm/blocs/main/main_cubit.dart';
import 'package:baharudin_alarm/blocs/statistic/statistic_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../models/alarm_model.dart';

class StatisticScreen extends StatelessWidget {
  const StatisticScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final mainCubit = context.read<MainCubit>();
    return BlocProvider<StatisticCubit>(
      create: (_) {
        return StatisticCubit(
          mainCubit: mainCubit,
        );
      },
      child: BlocBuilder<StatisticCubit, StatisticState>(
        builder: (context, state) {
          final statisticCubit = context.read<StatisticCubit>();
          return Column(children: [
            Padding(
              padding: EdgeInsets.only(
                top: height * 0.05,
                left: width * 0.05,
                right: width * 0.05,
                bottom: width * 0.01,
              ),
              child: _showChart(statisticCubit.seriesList),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  vertical: height * 0.05,
                  horizontal: width * 0.05,
                ),
                child: Column(
                  children: [
                    _showAlarmList(
                      'Today\'s Alarms',
                      statisticCubit.currentDayAlarms,
                      context,
                    ),
                    _showAlarmList(
                      'All Alarms',
                      state.alarms,
                      context,
                    ),
                  ],
                ),
              ),
            )
          ]);
        },
      ),
    );
  }

  Widget _showChart(List<ChartSeries<AlarmModel, String>> seriesList) {
    return SfCartesianChart(
      title: ChartTitle(alignment: ChartAlignment.center, text: 'Your Alarms'),
      series: seriesList,
      primaryYAxis: NumericAxis(
        title: AxisTitle(text: 'Waiting Time'),
        autoScrollingMode: AutoScrollingMode.start,
      ),
      primaryXAxis: CategoryAxis(
        title: AxisTitle(text: 'Date'),
        autoScrollingMode: AutoScrollingMode.start,
        maximumLabels: 10,
        autoScrollingDelta: 4,
      ),
      enableAxisAnimation: false,
      isTransposed: true,
      zoomPanBehavior: ZoomPanBehavior(enablePanning: true),
    );
  }

  List<Widget> _alarms(List<AlarmModel> alarms) {
    Widget alarmToWidget(AlarmModel alarm) {
      final waitingTime = alarm.waitingTime != null
          ? NumberFormat.decimalPattern('id').format(alarm.waitingTime)
          : null;
      final title = alarm.title;
      final subtitle = alarm.isActive
          ? 'Upcoming Alarm'
          : (waitingTime == null
              ? 'Missed alarm :('
              : 'Waiting time:   $waitingTime seconds');
      return ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
      );
    }

    return alarms.map((alarm) => alarmToWidget(alarm)).toList();
  }

  Widget _showAlarmList(
      String title, List<AlarmModel> alarms, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(
            height: 10,
          ),
          if (alarms.isEmpty) _noData(context),
          if (alarms.isNotEmpty) ..._alarms(alarms),
        ],
      ),
    );
  }

  Widget _noData(BuildContext context) {
    return Text(
      'Data not found :(',
      style: Theme.of(context).textTheme.titleLarge,
    );
  }
}
