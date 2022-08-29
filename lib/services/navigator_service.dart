import 'package:flutter/material.dart';

class NavigatorService {
  final GlobalKey<NavigatorState> _key;

  GlobalKey<NavigatorState> get key => _key;

  NavigatorService({required GlobalKey<NavigatorState> globalKey})
      : _key = globalKey;

  Future<T?> pushNamed<T extends Object?>(String routeName,
          {Object? args}) async =>
      _key.currentState?.pushNamed<T>(
        routeName,
        arguments: args,
      );

  Future<T?> push<T extends Object?>(Route<T> route) async =>
      _key.currentState?.push<T>(route);

  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
          String routeName,
          {Object? args}) async =>
      _key.currentState?.pushReplacementNamed<T, TO>(
        routeName,
        arguments: args,
      );

  Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
    String routeName, {
    Object? args,
    bool keepPreviousPages = false,
  }) async =>
      _key.currentState?.pushNamedAndRemoveUntil<T>(
        routeName,
        (Route<dynamic> route) => keepPreviousPages,
        arguments: args,
      );

  Future<T?> pushAndRemoveUntil<T extends Object?>(
    Route<T> route, {
    bool keepPreviousPages = false,
  }) async =>
      _key.currentState?.pushAndRemoveUntil<T>(
        route,
        (Route<dynamic> route) => keepPreviousPages,
      );

  bool canPop() => _key.currentState?.canPop() ?? false;
}
