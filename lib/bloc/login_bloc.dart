import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginSubmitted>((event, emit) async {
      emit(LoginLoading());
      await Future.delayed(const Duration(seconds: 1));

      if (event.username == "admin" && event.password == "12345") {
        emit(LoginSuccess(event.username));
      } else {
        emit(LoginFailure("error_login")); //Ky tu "error_login" se duoc dich
      }
    });
  }
}
