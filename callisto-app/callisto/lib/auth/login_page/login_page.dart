// auth.dart

import 'package:bloc/bloc.dart';

// Define the authentication bloc and events
enum AuthStatus { initial, authenticated, unauthenticated }

abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  final String token;

  LoginEvent({required this.token});
}

class LogoutEvent extends AuthEvent {}

class AuthBloc extends Bloc<AuthEvent, AuthStatus> {
  AuthBloc() : super(AuthStatus.initial);

  @override
  Stream<AuthStatus> mapEventToState(AuthEvent event) async* {
    if (event is LoginEvent) {
      yield AuthStatus.authenticated;
    } else if (event is LogoutEvent) {
      yield AuthStatus.unauthenticated;
    }
  }
}
