import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gmore/models/login_model.dart';
import 'package:gmore/services/auth_services.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      try {
        if (event is AuthLogin) {
          emit(AuthLoading());

          final res = await AuthServices().login(event.data);

          emit(AuthSuccess(res));
        }
      } catch (e) {
        emit(AuthFailed(e.toString()));
      }
    });
  }
}
