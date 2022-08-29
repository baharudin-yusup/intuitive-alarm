import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<DateTime> {
  late final Timer timer;

  HomeCubit() : super(DateTime.now()) {
    timer = Timer.periodic(const Duration(milliseconds: 50), _update);
  }

  void _update(Timer timer) {
    emit(DateTime.now());
  }

  @override
  Future<void> close() {
    timer.cancel();
    return super.close();
  }
}
