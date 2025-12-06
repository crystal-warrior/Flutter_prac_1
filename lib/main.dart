
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jhvostov_prac_1/app_router.dart';
import 'bloc_observer.dart';
import 'features/authorization/cubit/auth_cubit.dart';
import 'package:jhvostov_prac_1/shared/app_theme.dart';
import 'package:intl/date_symbol_data_local.dart';

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

  Bloc.observer = AppBlocObserver();
  initRouter();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: MaterialApp.router(
        routerConfig: appRouter,
        title: 'My Plants',
       // theme: ThemeData(primarySwatch: Colors.green),
        theme: AppTheme.lightTheme,
      ),
    );
  }
}