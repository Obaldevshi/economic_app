import 'package:mobile_template/app/theme/app_colors.dart';
import 'package:mobile_template/app/layout/app_layout_item_builder.dart';
import 'package:mobile_template/app/theme/app_dimensions.dart';
import 'package:mobile_template/core/extensions/build_context_extensions.dart';
import 'package:mobile_template/core/utils/validation_utils.dart';
import 'package:mobile_template/features/auth/presentation/pages/register/bloc/register_bloc.dart';
import 'package:mobile_template/features/auth/presentation/widgets/auth_link_text.dart';
import 'package:mobile_template/features/auth/presentation/widgets/auth_scroll_scaffold.dart';
import 'package:mobile_template/features/auth/presentation/widgets/login_hero_section.dart';
import 'package:mobile_template/presentation/widgets/common/error_dialog.dart';
import 'package:mobile_template/presentation/widgets/common/global_button.dart';
import 'package:mobile_template/presentation/widgets/common/global_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      context.read<RegisterBloc>().add(
        RegisterSubmitted(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          email: _emailController.text.trim().toLowerCase(),
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget firstNameField() => GlobalTextFormField(
      controller: _firstNameController,
      labelText: context.l10n.firstName,
      hintText: context.l10n.firstNameHint,
      validator: (value) =>
          ValidationUtils.validateName(value, context.l10n.firstName),
    );

    Widget lastNameField() => GlobalTextFormField(
      controller: _lastNameController,
      labelText: context.l10n.lastName,
      hintText: context.l10n.lastNameHint,
      validator: (value) =>
          ValidationUtils.validateName(value, context.l10n.lastName),
    );

    return BlocConsumer<RegisterBloc, RegisterState>(
      listener: (context, state) => _handleRegisterState(state),
      builder: (context, state) {
        return AuthScrollScaffold(
          hero: LoginHeroSection(
            title: context.l10n.createAccount,
            subtitle: context.l10n.registerSubtitle,
            showBackButton: true,
          ),
          form: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppLayoutItemBuilder<Widget>(
                  narrow: () => Column(
                    children: [
                      firstNameField(),
                      const SizedBox(height: AppDimensions.spaceL),
                      lastNameField(),
                    ],
                  ),
                  wide: () => Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: firstNameField()),
                      const SizedBox(width: AppDimensions.spaceM),
                      Expanded(child: lastNameField()),
                    ],
                  ),
                )(context),
                const SizedBox(height: AppDimensions.spaceL),
                GlobalTextFormField(
                  controller: _emailController,
                  labelText: context.l10n.email,
                  hintText: context.l10n.emailHint,
                  keyboardType: TextInputType.emailAddress,
                  validator: ValidationUtils.validateEmail,
                ),
                const SizedBox(height: AppDimensions.spaceL),
                GlobalTextFormField(
                  controller: _passwordController,
                  labelText: context.l10n.password,
                  hintText: context.l10n.createPasswordHint,
                  obscureText: !_isPasswordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                    onPressed: () => setState(
                      () => _isPasswordVisible = !_isPasswordVisible,
                    ),
                  ),
                  validator: ValidationUtils.validatePassword,
                ),
                const SizedBox(height: AppDimensions.spaceXL),
                GlobalButton(
                  text: context.l10n.createAccountButton,
                  onPressed: _handleRegister,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: AppDimensions.spaceXL),
                AuthLinkText(
                  normalText: context.l10n.alreadyHaveAccount,
                  linkText: context.l10n.signIn,
                  onTap: () => context.pop(),
                  onGradient: false,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleRegisterState(RegisterState state) {
    if (state is RegisterLoading) {
      setState(() => _isLoading = true);
    } else if (state is RegisterSuccess) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.accountCreatedSuccessfully),
          backgroundColor: AppColors.success,
        ),
      );
      context.pop();
    } else if (state is RegisterFailure) {
      setState(() => _isLoading = false);
      ErrorDialog.show(context, state.failure);
    }
  }
}
