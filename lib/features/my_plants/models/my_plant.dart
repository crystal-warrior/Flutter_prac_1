import 'dart:ui';

import 'package:flutter/material.dart';

class MyPlant {
  final String name;
  final int daysUntilWatering;


  String get health {
    if (daysUntilWatering == 0) return 'Срочно полей!';
    if (daysUntilWatering <= 3) return 'Нужен полив';
    return 'Отлично';
  }


  Color get healthColor {
    if (daysUntilWatering == 0) return Colors.red;
    if (daysUntilWatering <= 3) return Colors.orange;
    return Colors.lightGreen;
  }

  const MyPlant({
    required this.name,
    required this.daysUntilWatering,
  });
}