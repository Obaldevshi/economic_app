import 'package:mobile_template/app/layout/app_layout_item_builder.dart';
import 'package:mobile_template/app/theme/app_dimensions.dart';
import 'package:mobile_template/core/di/di.dart';
import 'package:mobile_template/core/extensions/build_context_extensions.dart';
import 'package:mobile_template/core/services/session_service.dart';
import 'package:mobile_template/core/utils/validation_utils.dart';
import 'package:mobile_template/features/profile/domain/dto/profile_dto.dart';
import 'package:mobile_template/features/profile/presentation/pages/bloc/profile_bloc.dart';
import 'package:mobile_template/features/profile/presentation/widgets/edit_profile_danger_zone.dart';
import 'package:mobile_template/features/profile/presentation/widgets/profile_header_card.dart';
import 'package:mobile_template/presentation/widgets/common/confirmation_dialog.dart';
import 'package:mobile_template/presentation/widgets/common/error_dialog.dart';
import 'package:mobile_template/presentation/widgets/common/glass_surface_card.dart';
import 'package:mobile_template/presentation/widgets/common/global_button.dart';
import 'package:mobile_template/presentation/widgets/common/global_text_form_field.dart';
import 'package:mobile_template/presentation/widgets/layout/scroll_shell.dart';
import 'package:mobile_template/presentation/widgets/ui_kit/ui_kit_section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key, required this.profile});

  final ProfileDto profile;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _sessionService = getIt<SessionService>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeData();
    for (final controller in [
      _firstNameController,
      _lastNameController,
      _emailController,
    ]) {
      controller.addListener(_onFormChanged);
    }
  }

  void _initializeData() {
    _firstNameController.text = widget.profile.firstName;
    _lastNameController.text = widget.profile.lastName;
    _emailController.text = widget.profile.email;
  }

  void _onFormChanged() => setState(() {});

  @override
  void dispose() {
    for (final controller in [
      _firstNameController,
      _lastNameController,
      _emailController,
    ]) {
      controller
        ..removeListener(_onFormChanged)
        ..dispose();
    }
    super.dispose();
  }

  ProfileDto get _previewProfile => ProfileDto(
    id: widget.profile.id,
    email: _emailController.text.trim(),
    firstName: _firstNameController.text.trim(),
    lastName: _lastNameController.text.trim(),
    createdAt: widget.profile.createdAt,
    updatedAt: widget.profile.updatedAt,
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      // ScrollShell самостоятельно резервирует место под IME.
      resizeToAvoidBottomInset: false,
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) => _handleProfileState(state),
        builder: (context, state) {
          return ScrollShell(
            isLoading: _isLoading,
            title: context.l10n.editProfile,
            leading: IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back_rounded),
            ),
            headerContent: Text(
              context.l10n.updatePersonalInfo,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.85),
              ),
            ),
            body: AppLayoutItemBuilder<Widget>(
              narrow: () => _buildNarrow(context),
              wide: () => _buildWide(context),
            )(context),
          );
        },
      ),
    );
  }

  Widget _buildNarrow(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ProfileHeaderCard(profile: _previewProfile),
        const SizedBox(height: AppDimensions.spaceL),
        _buildPersonalInformation(context),
        const SizedBox(height: AppDimensions.spaceXL),
        _buildDangerZone(context),
      ],
    );
  }

  Widget _buildWide(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ProfileHeaderCard(profile: _previewProfile),
              const SizedBox(height: AppDimensions.spaceL),
              _buildDangerZone(context),
            ],
          ),
        ),
        const SizedBox(width: AppDimensions.spaceL),
        Expanded(flex: 6, child: _buildPersonalInformation(context)),
      ],
    );
  }

  Widget _buildPersonalInformation(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        UiKitSectionTitle(title: context.l10n.personalInformation),
        GlassSurfaceCard(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppLayoutItemBuilder<Widget>(
                  narrow: () => Column(
                    children: [
                      _buildFirstNameField(context),
                      const SizedBox(height: AppDimensions.spaceM),
                      _buildLastNameField(context),
                    ],
                  ),
                  wide: () => Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildFirstNameField(context)),
                      const SizedBox(width: AppDimensions.spaceM),
                      Expanded(child: _buildLastNameField(context)),
                    ],
                  ),
                )(context),
                const SizedBox(height: AppDimensions.spaceM),
                _buildEmailField(context),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.spaceL),
        GlobalButton(
          onPressed: _saveProfile,
          text: context.l10n.saveChanges,
          isLoading: _isLoading,
        ),
      ],
    );
  }

  Widget _buildFirstNameField(BuildContext context) {
    return GlobalTextFormField(
      controller: _firstNameController,
      labelText: context.l10n.firstName,
      validator: (value) =>
          ValidationUtils.validateName(value, context.l10n.firstName, context),
    );
  }

  Widget _buildLastNameField(BuildContext context) {
    return GlobalTextFormField(
      controller: _lastNameController,
      labelText: context.l10n.lastName,
      validator: (value) =>
          ValidationUtils.validateName(value, context.l10n.lastName, context),
    );
  }

  Widget _buildEmailField(BuildContext context) {
    return GlobalTextFormField(
      controller: _emailController,
      labelText: context.l10n.email,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) return context.l10n.emailRequired;
        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return context.l10n.emailInvalid;
        }
        return null;
      },
    );
  }

  Widget _buildDangerZone(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        UiKitSectionTitle(title: context.l10n.dangerZone),
        EditProfileDangerZone(onDelete: _showDeleteAccountDialog),
      ],
    );
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      context.read<ProfileBloc>().add(
        UpdateProfileEvent(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          email: _emailController.text.trim(),
        ),
      );
    }
  }

  void _showDeleteAccountDialog() {
    ConfirmationDialog.show(
      context,
      title: context.l10n.deleteAccount,
      content: context.l10n.deleteAccountWarning,
      confirmText: context.l10n.deleteAccount,
      isDestructive: true,
      onConfirm: () => context.read<ProfileBloc>().add(DeleteAccountEvent()),
    );
  }

  void _handleProfileState(ProfileState state) {
    if (state is UpdateProfileLoading) {
      setState(() => _isLoading = true);
    } else if (state is UpdateProfileSuccess) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.profileUpdatedSuccessfully),
          backgroundColor: Colors.green,
        ),
      );
      context.pop(true);
    } else if (state is UpdateProfileFailure) {
      setState(() => _isLoading = false);
      ErrorDialog.show(context, state.failure);
    } else if (state is DeleteAccountSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.accountDeletedSuccessfully),
          backgroundColor: Colors.green,
        ),
      );
      _sessionService.clearSession();
    } else if (state is DeleteAccountFailure) {
      ErrorDialog.show(context, state.failure);
    }
  }
}
