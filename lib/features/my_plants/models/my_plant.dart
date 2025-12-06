import 'dart:ui';

import 'package:flutter/material.dart';

class MyPlant {
  final String name;
  final int daysUntilWatering;


  String get health {
    if (daysUntilWatering >= 8) return 'Срочно полейте растение!';
    if (daysUntilWatering >= 4 && daysUntilWatering <= 7) return 'Требуется орошение!';
    return 'Состояние отличное!';
  }


  Color get healthColor {
    if (daysUntilWatering == 0 || daysUntilWatering == 1 || daysUntilWatering == 2 || daysUntilWatering == 3) return Colors.lightGreen;
    if (daysUntilWatering >= 4 && daysUntilWatering <= 7) return Colors.orange;
    return Colors.red;
  }

  const MyPlant({
    required this.name,
    required this.daysUntilWatering,
  });
}