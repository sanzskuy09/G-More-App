part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

final class AuthLogin extends AuthEvent {
  final LoginModel data;

  const AuthLogin(this.data);

  @override
  List<Object> get props => [data];
}
