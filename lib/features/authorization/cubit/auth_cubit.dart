// lib/features/authorization/cubit/auth_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jhvostov_prac_1/models/user.dart';

class AuthState {
  final User? user;
  const AuthState({this.user});

  AuthState copyWith({User? user}) => AuthState(user: user ?? this.user);
  bool get isAuthenticated => user != null;
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState());

  void setUser(User user) => emit(state.copyWith(user: user));
  void logout() => emit(const AuthState());
}