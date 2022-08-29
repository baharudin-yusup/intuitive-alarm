import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TextClock extends StatelessWidget {
  final DateTime time;
  final bool use12HourFormat;
  final bool showFullTitle;

  const TextClock({
    Key? key,
    required this.time,
    this.use12HourFormat = false,
    this.showFullTitle = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.titleLarge;
    return Column(
      children: [
        show(style),
      ],
    );
  }

  Widget show(TextStyle? style) {
    late final String title;
    if (showFullTitle) {
      title = DateFormat.yMEd().add_jms().format(time);
    } else {
      final isPM = time.hour >= 12;
      final hour = (use12HourFormat && isPM ? time.hour - 12 : time.hour)
          .toString()
          .padLeft(2, '0');
      final minute = time.minute.toString().padLeft(2, '0');
      final second = time.second.toString().padLeft(2, '0');
      final prefix = use12HourFormat ? (isPM ? ' PM' : ' AM') : '';
      title = '$hour:$minute:$second$prefix';
    }

    return Text(title, style: style);
  }
}
