extension BaharudinTime on DateTime {
  double get minuteToHour => minute / 60;

  double get secondToMinute => second / 60;

  double get secondToHour => second / 3600;

  double get millisecondToSecond => millisecond / 1000;
}
