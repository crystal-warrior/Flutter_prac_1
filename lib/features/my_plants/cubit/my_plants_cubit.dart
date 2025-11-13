import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/my_plant.dart';

class MyPlantsState {
  final List<MyPlant> plants;

  const MyPlantsState({required this.plants});

  MyPlantsState copyWith({List<MyPlant>? plants}) {
    return MyPlantsState(plants: plants ?? this.plants);
  }
}

class MyPlantsCubit extends Cubit<MyPlantsState> {
  MyPlantsCubit()
      : super(
    const MyPlantsState(
      plants: [
        MyPlant(name: 'Кактус', daysUntilWatering: 7),
        MyPlant(name: 'Фикус', daysUntilWatering: 3),
        MyPlant(name: 'Роза', daysUntilWatering: 1),
      ],
    ),
  );

  void addPlant(String name, String daysStr) {
    final days = int.tryParse(daysStr.trim()) ?? 0;
    if (name.trim().isNotEmpty) {
      final newPlant = MyPlant(name: name.trim(), daysUntilWatering: days);
      final updated = List<MyPlant>.from(state.plants)..add(newPlant);
      emit(state.copyWith(plants: updated));
    }
  }

  void removePlant(int index) {
    if (index >= 0 && index < state.plants.length) {
      final updated = List<MyPlant>.from(state.plants)..removeAt(index);
      emit(state.copyWith(plants: updated));
    }
  }
}