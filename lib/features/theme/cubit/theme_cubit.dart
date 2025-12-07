import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/datasources/local/shared_preferences_data_source.dart';
import '../../../../domain/usecases/authenticate_usecase.dart';
import '../../../../di/service_locator.dart';

enum AppThemeMode {
  dayGarden, // Дневной сад
  nightGarden, // Ночной сад
}

class ThemeState {
  final AppThemeMode themeMode;

  const ThemeState({required this.themeMode});

  ThemeState copyWith({AppThemeMode? themeMode}) {
    return ThemeState(themeMode: themeMode ?? this.themeMode);
  }
}

class ThemeCubit extends Cubit<ThemeState> {
  final SharedPreferencesDataSource _sharedPrefs;
  final AuthenticateUseCase _authenticateUseCase;

  ThemeCubit({
    SharedPreferencesDataSource? sharedPrefs,
    AuthenticateUseCase? authenticateUseCase,
  })  : _sharedPrefs = sharedPrefs ?? locator<SharedPreferencesDataSource>(),
        _authenticateUseCase = authenticateUseCase ?? locator<AuthenticateUseCase>(),
        super(const ThemeState(themeMode: AppThemeMode.dayGarden)) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    // Сначала пытаемся загрузить тему текущего пользователя
    final user = await _authenticateUseCase.getCurrentUser();
    if (user != null) {
      final userTheme = await _sharedPrefs.getUserThemeMode(user.login);
      if (userTheme != null) {
        final themeMode = userTheme == 'nightGarden'
            ? AppThemeMode.nightGarden
            : AppThemeMode.dayGarden;
        emit(state.copyWith(themeMode: themeMode));
        print('✅ Загружена тема пользователя ${user.login}: $userTheme');
        return;
      }
    }
    
    // Если пользователь не авторизован, всегда используем дефолтную тему (Дневной сад)
    // Это гарантирует, что после выхода из аккаунта тема будет светлой
    emit(const ThemeState(themeMode: AppThemeMode.dayGarden));
    print('✅ Пользователь не авторизован, используется дефолтная тема: dayGarden');
  }

  Future<void> setTheme(AppThemeMode themeMode) async {
    emit(state.copyWith(themeMode: themeMode));
    final themeString = themeMode == AppThemeMode.nightGarden ? 'nightGarden' : 'dayGarden';
    
    // Сохраняем тему для текущего пользователя
    final user = await _authenticateUseCase.getCurrentUser();
    if (user != null) {
      await _sharedPrefs.saveUserThemeMode(user.login, themeString);
    } else {
      // Если пользователь не авторизован, сохраняем глобальную тему
      await _sharedPrefs.saveThemeMode(themeString);
    }
  }

  Future<void> toggleTheme() async {
    final newTheme = state.themeMode == AppThemeMode.dayGarden
        ? AppThemeMode.nightGarden
        : AppThemeMode.dayGarden;
    await setTheme(newTheme);
  }

  // Загрузка темы для конкретного пользователя (вызывается при входе)
  Future<void> loadUserTheme(String login) async {
    final userTheme = await _sharedPrefs.getUserThemeMode(login);
    if (userTheme != null) {
      final themeMode = userTheme == 'nightGarden'
          ? AppThemeMode.nightGarden
          : AppThemeMode.dayGarden;
      emit(state.copyWith(themeMode: themeMode));
    }
  }

  // Сброс темы на дефолтную (вызывается при выходе)
  Future<void> resetTheme() async {
    // Сначала устанавливаем дефолтную тему в состояние
    emit(const ThemeState(themeMode: AppThemeMode.dayGarden));
    // Затем сохраняем в SharedPreferences
    await _sharedPrefs.resetThemeMode();
    print('🔄 Тема сброшена на Дневной сад');
  }
}

