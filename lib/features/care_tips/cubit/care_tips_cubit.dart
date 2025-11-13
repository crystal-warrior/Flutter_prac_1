import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/care_tip.dart';

class CareTipsState {
  final List<CareTip> tips;

  const CareTipsState({required this.tips});

  CareTipsState copyWith({List<CareTip>? tips}) {
    return CareTipsState(tips: tips ?? this.tips);
  }
}

class CareTipsCubit extends Cubit<CareTipsState> {
  CareTipsCubit()
      : super(
    const CareTipsState(
      tips: [
        CareTip(title: 'Полив', tip: 'Поливайте утром или вечером'),
        CareTip(title: 'Свет', tip: 'Обеспечьте достаточно солнечного света'),
        CareTip(title: 'Температура', tip: 'Избегайте резких перепадов температуры'),
        CareTip(title: 'Почва', tip: 'Используйте качественную почвенную смесь'),
        CareTip(title: 'Обрезка', tip: 'Регулярно обрезайте сухие листья'),
        CareTip(title: 'Подкормка', tip: 'Удобряйте растения в период активного роста'),
        CareTip(title: 'Влажность', tip: 'Опрыскивайте листья тропических растений'),
        CareTip(title: 'Дренаж', tip: 'Используйте дренаж на дне горшка для отвода лишней воды'),
        CareTip(title: 'Пересадка', tip: 'Пересаживайте растения весной в горшок на 2-3 см больше'),
        CareTip(title: 'Вредители', tip: 'Регулярно осматривайте растения на наличие вредителей'),
        CareTip(title: 'Проветривание', tip: 'Обеспечьте циркуляцию воздуха вокруг растений'),
      ],
    ),
  );

  void addTip(String title, String tip) {
    if (title.trim().isNotEmpty && tip.trim().isNotEmpty) {
      final newTip = CareTip(title: title.trim(), tip: tip.trim());
      final updated = List<CareTip>.from(state.tips)..add(newTip);
      emit(state.copyWith(tips: updated));
    }
  }

  void removeTip(int index) {
    if (index >= 0 && index < state.tips.length) {
      final updated = List<CareTip>.from(state.tips)..removeAt(index);
      emit(state.copyWith(tips: updated));
    }
  }
}