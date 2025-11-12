
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jhvostov_prac_1/app_router.dart';
import 'bloc_observer.dart';
import 'auth/cubit/auth_cubit.dart';

void main() {
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
        theme: ThemeData(primarySwatch: Colors.green),
      ),
    );
  }
}