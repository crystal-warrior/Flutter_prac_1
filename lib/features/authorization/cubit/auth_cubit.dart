import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/models/user.dart';
import '../../../../domain/usecases/authenticate_usecase.dart';
import '../../../../domain/usecases/register_usecase.dart';
import '../../../../domain/repositories/auth_repository.dart';
import '../../theme/cubit/theme_cubit.dart';
import '../../../../di/service_locator.dart';

class AuthState {
  final User? user;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    User? user,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  bool get isAuthenticated => user != null;
}

class AuthCubit extends Cubit<AuthState> {
  final AuthenticateUseCase _authenticateUseCase;
  final RegisterUseCase _registerUseCase;

  AuthCubit({
    AuthenticateUseCase? authenticateUseCase,
    RegisterUseCase? registerUseCase,
  })  : _authenticateUseCase = authenticateUseCase ?? locator<AuthenticateUseCase>(),
        _registerUseCase = registerUseCase ?? locator<RegisterUseCase>(),
        super(const AuthState()) {
    _loadSavedUser();
  }

  // Загрузка сохраненного пользователя при инициализации
  Future<void> _loadSavedUser() async {
    try {
      final user = await _authenticateUseCase.getCurrentUser();
      if (user != null) {
        emit(state.copyWith(user: user));
        // Загружаем тему пользователя после восстановления сессии
        try {
          final themeCubit = locator<ThemeCubit>();
          await themeCubit.loadUserTheme(user.login);
        } catch (e) {
          // Игнорируем ошибки загрузки темы
        }
      }
    } catch (e) {
      // Игнорируем ошибки при загрузке
    }
  }

  Future<void> authenticate(String login, String password) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final user = await _authenticateUseCase(login, password);
      if (user != null) {
        emit(state.copyWith(user: user, isLoading: false));
        // Загружаем тему пользователя после успешного входа
        try {
          final themeCubit = locator<ThemeCubit>();
          await themeCubit.loadUserTheme(login);
        } catch (e) {
          // Игнорируем ошибки загрузки темы
        }
      } else {
        emit(state.copyWith(isLoading: false, error: 'Неверный логин или пароль'));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> register(User user) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      await _registerUseCase(user);
      emit(state.copyWith(user: user, isLoading: false));
      // Загружаем тему пользователя после успешной регистрации
      // У нового пользователя будет дефолтная тема (dayGarden)
      try {
        final themeCubit = locator<ThemeCubit>();
        await themeCubit.loadUserTheme(user.login);
      } catch (e) {
        // Игнорируем ошибки загрузки темы
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void setUser(User user) => emit(state.copyWith(user: user));

  Future<void> logout() async {
    // Сначала сбрасываем тему на дефолтную при выходе
    try {
      final themeCubit = locator<ThemeCubit>();
      await themeCubit.resetTheme();
    } catch (e) {
      print('❌ Ошибка при сбросе темы: $e');
    }
    // Затем вызываем метод репозитория для очистки хранилищ
    try {
      final repository = locator<AuthRepository>();
      await repository.logout();
    } catch (e) {
      print('❌ Ошибка при выходе: $e');
    }
    emit(const AuthState());
  }
}
