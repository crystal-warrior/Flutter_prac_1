
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jhvostov_prac_1/app_router.dart';
import 'bloc_observer.dart';
import 'features/authorization/cubit/auth_cubit.dart';
import 'features/theme/cubit/theme_cubit.dart';
import 'package:jhvostov_prac_1/shared/app_theme.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:jhvostov_prac_1/di/service_locator.dart';

/*
void main() {
  Bloc.observer = AppBlocObserver();

  initRouter();

  runApp(const MyApp());
}

 */

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ru_RU', null);

  setupLocator();

  Bloc.observer = AppBlocObserver();
  initRouter();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Используем ThemeCubit из service locator (уже зарегистрирован при setupLocator)
    final themeCubit = locator<ThemeCubit>();

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider.value(value: themeCubit),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp.router(
            routerConfig: appRouter,
            title: 'My Plants',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeState.themeMode == AppThemeMode.nightGarden
                ? ThemeMode.dark
                : ThemeMode.light,
            locale: const Locale('ru', 'RU'),
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('ru', 'RU'),
              Locale('en', 'US'),
            ],
          );
        },
      ),
    );
  }
}