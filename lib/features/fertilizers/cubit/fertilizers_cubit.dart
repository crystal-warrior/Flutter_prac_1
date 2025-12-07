import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/models/fertilizer.dart';
import '../../../../domain/usecases/add_fertilizer_usecase.dart';
import '../../../../domain/usecases/get_fertilizers_usecase.dart';
import '../../../../di/service_locator.dart';

class FertilizersState {
  final List<Fertilizer> fertilizers;
  final bool isLoading;
  final String? error;

  const FertilizersState({
    required this.fertilizers,
    this.isLoading = false,
    this.error,
  });

  FertilizersState copyWith({
    List<Fertilizer>? fertilizers,
    bool? isLoading,
    String? error,
  }) {
    return FertilizersState(
      fertilizers: fertilizers ?? this.fertilizers,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class FertilizersCubit extends Cubit<FertilizersState> {
  final GetFertilizersUseCase _getFertilizersUseCase;
  final AddFertilizerUseCase _addFertilizerUseCase;

  FertilizersCubit({
    GetFertilizersUseCase? getFertilizersUseCase,
    AddFertilizerUseCase? addFertilizerUseCase,
  })  : _getFertilizersUseCase = getFertilizersUseCase ?? locator<GetFertilizersUseCase>(),
        _addFertilizerUseCase = addFertilizerUseCase ?? locator<AddFertilizerUseCase>(),
        super(const FertilizersState(fertilizers: [])) {
    loadFertilizers();
  }

  Future<void> loadFertilizers() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final fertilizers = await _getFertilizersUseCase();
      emit(state.copyWith(fertilizers: fertilizers, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> addFertilizer(String name, String? description, String? application, String? composition) async {
    if (name.trim().isNotEmpty) {
      try {
        final fertilizer = Fertilizer(
          name: name.trim(),
          description: description,
          application: application,
          composition: composition,
        );
        await _addFertilizerUseCase(fertilizer);
        await loadFertilizers();
      } catch (e) {
        emit(state.copyWith(error: e.toString()));
      }
    }
  }

  Future<void> removeFertilizer(int index) async {
    if (index >= 0 && index < state.fertilizers.length) {
      // TODO: Implement remove use case if needed
      final updated = List<Fertilizer>.from(state.fertilizers)..removeAt(index);
      emit(state.copyWith(fertilizers: updated));
    }
  }
}
