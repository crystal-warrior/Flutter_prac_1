
import 'package:flutter_bloc/flutter_bloc.dart';

class WateringState {
  final int waterLevel;

  const WateringState({required this.waterLevel});

  WateringState copyWith({int? waterLevel}) {
    return WateringState(waterLevel: waterLevel ?? this.waterLevel);
  }
}

class WateringCubit extends Cubit<WateringState> {
  WateringCubit() : super(const WateringState(waterLevel: 0));

  void setWaterLevel(int level) {
    emit(state.copyWith(waterLevel: level));
  }

  void reset() {
    emit(const WateringState(waterLevel: 0));
  }
}