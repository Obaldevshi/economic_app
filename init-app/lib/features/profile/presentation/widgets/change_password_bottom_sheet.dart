import 'package:mobile_template/app/theme/app_colors.dart';
import 'package:mobile_template/app/theme/app_dimensions.dart';
import 'package:mobile_template/core/extensions/build_context_extensions.dart';
import 'package:mobile_template/features/profile/presentation/pages/bloc/profile_bloc.dart';
import 'package:mobile_template/features/auth/presentation/widgets/password_text_field.dart';
import 'package:mobile_template/presentation/widgets/common/error_dialog.dart';
import 'package:mobile_template/presentation/widgets/common/glass_bottom_sheet.dart';
import 'package:mobile_template/presentation/widgets/common/global_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordBottomSheet extends StatefulWidget {
  const ChangePasswordBottomSheet({super.key});

  static Future<bool?> show(BuildContext context) {
    return GlassBottomSheet.show<bool>(
      context,
      title: context.l10n.changePasswordTitle,
      child: BlocProvider.value(
        value: context.read<ProfileBloc>(),
        child: const ChangePasswordBottomSheet(),
      ),
    );
  }

  @override
  State<ChangePasswordBottomSheet> createState() =>
      _ChangePasswordBottomSheetState();
}

class _ChangePasswordBottomSheetState extends State<ChangePasswordBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        _handlePasswordState(state);
      },
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PasswordTextField(
                controller: _currentPasswordController,
                labelText: context.l10n.currentPassword,
                hintText: context.l10n.enterCurrentPassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return context.l10n.currentPasswordRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppDimensions.spaceM),
              PasswordTextField(
                controller: _newPasswordController,
                labelText: context.l10n.newPassword,
                hintText: context.l10n.enterNewPassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return context.l10n.newPasswordRequired;
                  }
                  if (value.length < 8) {
                    return context.l10n.newPasswordTooShort(8);
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppDimensions.spaceM),
              PasswordTextField(
                controller: _confirmPasswordController,
                labelText: context.l10n.confirmNewPassword,
                hintText: context.l10n.confirmYourNewPassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return context.l10n.fieldRequired(
                      context.l10n.confirmNewPassword,
                    );
                  }
                  if (value != _newPasswordController.text) {
                    return context.l10n.passwordsDontMatch;
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppDimensions.spaceXL),
              GlobalButton(
                onPressed: _changePassword,
                text: context.l10n.changePasswordButton,
                isLoading: _isLoading,
              ),
            ],
          ),
        );
      },
    );
  }

  void _changePassword() {
    if (_formKey.currentState!.validate()) {
      context.read<ProfileBloc>().add(
        ChangePasswordEvent(
          currentPassword: _currentPasswordController.text,
          newPassword: _newPasswordController.text,
        ),
      );
    }
  }

  void _handlePasswordState(ProfileState state) {
    if (state is ChangePasswordLoading) {
      setState(() => _isLoading = true);
    } else if (state is ChangePasswordSuccess) {
      setState(() => _isLoading = false);
      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.passwordChangedSuccessfully),
          backgroundColor: AppColors.success,
        ),
      );
    } else if (state is ChangePasswordFailure) {
      setState(() => _isLoading = false);
      ErrorDialog.show(context, state.failure);
    }
  }
}
