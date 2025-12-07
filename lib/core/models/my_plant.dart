import 'package:flutter/material.dart';

class MyPlant {
  final String name;
  final DateTime lastWateringDate; // Дата последнего полива
  final int wateringInterval; // Интервал полива в днях (для обратной совместимости)

  MyPlant({
    required this.name,
    DateTime? lastWateringDate,
    int? daysUntilWatering, // Для обратной совместимости
    int? wateringInterval,
  })  : lastWateringDate = lastWateringDate ?? 
          (daysUntilWatering != null 
            ? DateTime.now().subtract(Duration(days: daysUntilWatering))
            : DateTime.now()),
        wateringInterval = wateringInterval ?? 7;

  // Вычисляемое свойство: дни с последнего полива
  int get daysUntilWatering {
    final now = DateTime.now();
    final difference = now.difference(lastWateringDate).inDays;
    return difference;
  }

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

  bool get needsUrgentWatering => daysUntilWatering >= 8;
  bool get needsWatering => daysUntilWatering >= 4 && daysUntilWatering <= 7;
  bool get isHealthy => daysUntilWatering < 4;
}

