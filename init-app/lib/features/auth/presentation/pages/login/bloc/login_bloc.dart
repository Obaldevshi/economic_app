import 'package:equatable/equatable.dart';
import 'package:mobile_template/core/errors/failure.dart';
import 'package:mobile_template/data/models/request/login_request.dart';
import 'package:mobile_template/features/auth/domain/dto/login_dto.dart';
import 'package:mobile_template/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUsecase loginUsecase;
  LoginBloc({required this.loginUsecase}) : super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    final request = LoginRequest(email: event.email, password: event.password);
    final result = await loginUsecase.call(request);
    result.fold(
      (failure) {
        emit(LoginFailure(failure: failure));
      },
      (data) {
        emit(LoginSuccess(data: data));
      },
    );
  }
}
