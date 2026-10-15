import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_template/core/errors/failure.dart';
import 'package:mobile_template/data/models/request/password_reset_request.dart';
import 'package:mobile_template/data/repositories/password_reset_repository.dart';

sealed class PasswordResetEvent {
  const PasswordResetEvent();
}

// No toString/Equatable props containing passwords or recovery codes.
class RequestPasswordResetCode extends PasswordResetEvent {
  const RequestPasswordResetCode(this.email, this.language);
  final String email;
  final String language;
}

class ConfirmPasswordReset extends PasswordResetEvent {
  const ConfirmPasswordReset(this.email, this.code, this.newPassword);
  final String email;
  final String code;
  final String newPassword;
}

class ChangePasswordResetEmail extends PasswordResetEvent {
  const ChangePasswordResetEmail();
}

class PasswordResetState extends Equatable {
  const PasswordResetState({
    this.busy = false,
    this.codeRequested = false,
    this.completed = false,
    this.resendAt,
    this.failure,
  });
  final bool busy;
  final bool codeRequested;
  final bool completed;
  final DateTime? resendAt;
  final Failure? failure;
  PasswordResetState copyWith({
    bool? busy,
    bool? codeRequested,
    bool? completed,
    DateTime? resendAt,
    Failure? failure,
    bool clearFailure = false,
  }) => PasswordResetState(
    busy: busy ?? this.busy,
    codeRequested: codeRequested ?? this.codeRequested,
    completed: completed ?? this.completed,
    resendAt: resendAt ?? this.resendAt,
    failure: clearFailure ? null : failure ?? this.failure,
  );
  @override
  List<Object?> get props => [
    busy,
    codeRequested,
    completed,
    resendAt,
    failure,
  ];
}

class PasswordResetBloc extends Bloc<PasswordResetEvent, PasswordResetState> {
  PasswordResetBloc(this._repository) : super(const PasswordResetState()) {
    on<RequestPasswordResetCode>((event, emit) async {
      if (state.busy ||
          state.completed ||
          (state.resendAt?.isAfter(DateTime.now()) ?? false)) {
        return;
      }
      emit(state.copyWith(busy: true, clearFailure: true));
      final result = await _repository.requestCode(
        PasswordResetRequest(email: event.email, language: event.language),
      );
      if (emit.isDone) {
        return;
      }
      result.fold(
        (error) => emit(state.copyWith(busy: false, failure: error)),
        (_) => emit(
          state.copyWith(
            busy: false,
            codeRequested: true,
            resendAt: DateTime.now().add(const Duration(seconds: 60)),
            clearFailure: true,
          ),
        ),
      );
    });
    on<ConfirmPasswordReset>((event, emit) async {
      if (state.busy || !state.codeRequested || state.completed) {
        return;
      }
      emit(state.copyWith(busy: true, clearFailure: true));
      final result = await _repository.confirm(
        PasswordResetConfirmRequest(
          email: event.email,
          code: event.code,
          newPassword: event.newPassword,
        ),
      );
      if (emit.isDone) {
        return;
      }
      result.fold(
        (error) => emit(state.copyWith(busy: false, failure: error)),
        (_) => emit(
          state.copyWith(busy: false, completed: true, clearFailure: true),
        ),
      );
    });
    on<ChangePasswordResetEmail>((event, emit) {
      if (!state.busy && !state.completed) {
        emit(const PasswordResetState());
      }
    });
  }
  final PasswordResetRepository _repository;
}
