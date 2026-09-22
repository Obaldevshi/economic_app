import 'package:equatable/equatable.dart';
import 'package:mobile_template/core/errors/failure.dart';
import 'package:mobile_template/data/models/request/change_password_request.dart';
import 'package:mobile_template/data/models/request/update_profile_request.dart';
import 'package:mobile_template/features/profile/domain/dto/profile_dto.dart';
import 'package:mobile_template/features/profile/domain/usecases/change_password_usecase.dart';
import 'package:mobile_template/features/profile/domain/usecases/delete_account_usecase.dart';
import 'package:mobile_template/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:mobile_template/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUsecase _getProfileUsecase;
  final UpdateProfileUsecase _updateProfileUsecase;
  final DeleteAccountUsecase _deleteAccountUsecase;
  final ChangePasswordUsecase _changePasswordUsecase;

  ProfileBloc(
    this._getProfileUsecase,
    this._updateProfileUsecase,
    this._deleteAccountUsecase,
    this._changePasswordUsecase,
  ) : super(ProfileInitial()) {
    on<GetProfileEvent>(_onGetProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
    on<DeleteAccountEvent>(_onDeleteAccount);
    on<ChangePasswordEvent>(_onChangePassword);
  }

  Future<void> _onGetProfile(
    GetProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(GetProfileLoading(data: state.data));
    final result = await _getProfileUsecase.call();
    result.fold(
      (failure) => emit(GetProfileFailure(failure: failure, data: state.data)),
      (profile) =>
          emit(GetProfileSuccess(data: state.data.copyWith(profile: profile))),
    );
  }

  Future<void> _onUpdateProfile(
    UpdateProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(UpdateProfileLoading(data: state.data));
    final request = UpdateProfileRequest(
      firstName: event.firstName,
      lastName: event.lastName,
      email: event.email,
    );
    final result = await _updateProfileUsecase.call(request);
    result.fold(
      (failure) =>
          emit(UpdateProfileFailure(failure: failure, data: state.data)),
      (message) => emit(
        UpdateProfileSuccess(data: state.data.copyWith(message: message)),
      ),
    );
  }

  Future<void> _onDeleteAccount(
    DeleteAccountEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(DeleteAccountLoading(data: state.data));
    final result = await _deleteAccountUsecase.call();
    result.fold(
      (failure) =>
          emit(DeleteAccountFailure(failure: failure, data: state.data)),
      (_) => emit(DeleteAccountSuccess(data: state.data)),
    );
  }

  Future<void> _onChangePassword(
    ChangePasswordEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ChangePasswordLoading(data: state.data));
    final request = ChangePasswordRequest(
      currentPassword: event.currentPassword,
      newPassword: event.newPassword,
    );
    final result = await _changePasswordUsecase.call(request);
    result.fold(
      (failure) =>
          emit(ChangePasswordFailure(failure: failure, data: state.data)),
      (message) => emit(
        ChangePasswordSuccess(data: state.data.copyWith(message: message)),
      ),
    );
  }
}
