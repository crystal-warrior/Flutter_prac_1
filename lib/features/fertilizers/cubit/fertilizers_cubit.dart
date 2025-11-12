
import 'package:flutter_bloc/flutter_bloc.dart';

class FertilizersState {
  final List<String> fertilizers;

  const FertilizersState({required this.fertilizers});

  FertilizersState copyWith({List<String>? fertilizers}) {
    return FertilizersState(fertilizers: fertilizers ?? this.fertilizers);
  }
}

class FertilizersCubit extends Cubit<FertilizersState> {
  FertilizersCubit()
      : super(
    const FertilizersState(
      fertilizers: [
        'Органические удобрения',
        'Минеральные удобрения',
        'Комплексные удобрения',
        'Специальные смеси для цветов',
        'Удобрения для кактусов',
      ],
    ),
  );

  void addFertilizer(String name) {
    if (name.trim().isNotEmpty) {
      final updated = List<String>.from(state.fertilizers)..add(name.trim());
      emit(state.copyWith(fertilizers: updated));
    }
  }

  void removeFertilizer(int index) {
    if (index >= 0 && index < state.fertilizers.length) {
      final updated = List<String>.from(state.fertilizers)..removeAt(index);
      emit(state.copyWith(fertilizers: updated));
    }
  }
}