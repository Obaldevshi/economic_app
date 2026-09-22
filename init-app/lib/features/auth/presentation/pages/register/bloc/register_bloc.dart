import 'package:equatable/equatable.dart';
import 'package:mobile_template/core/errors/failure.dart';
import 'package:mobile_template/data/models/request/register_request.dart';
import 'package:mobile_template/features/auth/domain/usecases/register_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterUsecase registerUsecase;

  RegisterBloc(this.registerUsecase) : super(RegisterInitial()) {
    on<RegisterSubmitted>(_onRegisterSubmitted);
  }

  Future<void> _onRegisterSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    emit(RegisterLoading());
    final request = RegisterRequest(
      firstName: event.firstName,
      lastName: event.lastName,
      email: event.email,
      password: event.password,
    );
    final result = await registerUsecase.call(request);
    result.fold(
      (failure) {
        emit(RegisterFailure(failure: failure));
      },
      (message) {
        emit(RegisterSuccess(message: message));
      },
    );
  }
}
