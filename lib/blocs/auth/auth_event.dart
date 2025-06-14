part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

final class AuthRegister extends AuthEvent {
  final RegisterModel data;
  const AuthRegister(this.data);

  @override
  List<Object> get props => [data];
}

final class AuthLogin extends AuthEvent {
  final LoginModel data;
  const AuthLogin(this.data);

  @override
  List<Object> get props => [data];
}

class AuthGetUserCredential extends AuthEvent {}

class AuthCheck extends AuthEvent {
  final String token;
  const AuthCheck(this.token);

  @override
  List<Object> get props => [token];
}
