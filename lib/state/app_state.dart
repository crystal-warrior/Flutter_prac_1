import 'package:flutter/material.dart';

class AppState extends InheritedWidget {
  final String? login;

  const AppState({
    Key? key,
    required Widget child,
    this.login,
  }) : super(key: key, child: child);

  static AppState of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<AppState>();
    assert(result != null, 'AppState not found in widget tree.');
    return result!;
  }

  @override
  bool updateShouldNotify(AppState oldWidget) {
    return login != oldWidget.login;
  }
}