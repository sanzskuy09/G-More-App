part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthFailed extends AuthState {
  final String err;
  const AuthFailed(this.err);

  @override
  List<Object> get props => [err];
}

final class AuthSuccess extends AuthState {
  final LoginModel data;
  const AuthSuccess(this.data);

  @override
  List<Object> get props => [data];
}
