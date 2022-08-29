import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class AlarmModel extends Equatable {
  final String id;
  final DateTime createdAt;
  final DateTime? openedAt;

  const AlarmModel({
    required this.createdAt,
    required this.id,
    this.openedAt,
  });

  String get title {
    return DateFormat.yMEd().add_jms().format(createdAt);
  }

  String get barTitle {
    final month = createdAt.month.toString().padLeft(2, '0');
    final day = createdAt.day.toString().padLeft(2, '0');
    final hour = createdAt.hour.toString().padLeft(2, '0');
    final minute = createdAt.minute.toString().padLeft(2, '0');
    final second = createdAt.second.toString().padLeft(2, '0');

    return '$day/$month\n$hour:$minute:$second';
  }

  bool get isActive {
    final currentTime = DateTime.now();
    if (openedAt != null) {
      return false;
    }

    if (currentTime.isAfter(createdAt)) {
      return false;
    }

    return true;
  }

  int? get waitingTime {
    if (openedAt == null) {
      return null;
    }

    final durationInMs =
        openedAt!.millisecondsSinceEpoch - createdAt.millisecondsSinceEpoch;
    return durationInMs ~/ 1000;
  }

  factory AlarmModel.fromBloc({required DateTime time}) {
    final id = const Uuid().v4();
    return AlarmModel(
      id: id,
      createdAt: time,
    );
  }

  factory AlarmModel.fromJson(Map<String, dynamic> json) {
    return AlarmModel(
      createdAt: DateTime.parse(json['created-at']),
      id: json['id'],
      openedAt:
          json['opened-at'] != null ? DateTime.parse(json['opened-at']) : null,
    );
  }

  AlarmModel copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? openedAt,
  }) {
    return AlarmModel(
      createdAt: createdAt ?? this.createdAt,
      openedAt: openedAt ?? this.openedAt,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created-at': createdAt.toIso8601String(),
      'opened-at': openedAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        createdAt,
        openedAt,
      ];
}
