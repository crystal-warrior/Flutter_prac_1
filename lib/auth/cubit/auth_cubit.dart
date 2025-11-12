import 'package:flutter_bloc/flutter_bloc.dart';

class AuthState {
  final String? login;

  const AuthState({this.login});

  AuthState copyWith({String? login}) {
    return AuthState(login: login ?? this.login);
  }
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState());

  void setLogin(String login) {
    emit(state.copyWith(login: login));
  }

  void logout() {
    emit(const AuthState());
  }

  bool get isAuthenticated => state.login != null && state.login!.isNotEmpty;
}