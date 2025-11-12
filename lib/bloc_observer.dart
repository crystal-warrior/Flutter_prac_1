import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase<dynamic> cubit, Change<dynamic> change) {
    super.onChange(cubit, change);
    print('Bloc/Cubit: ${cubit.runtimeType}, Change: $change');
  }
}