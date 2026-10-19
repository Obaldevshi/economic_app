import 'package:mobile_template/app/app_router.dart';
import 'package:mobile_template/app/theme/app_dimensions.dart';
import 'package:mobile_template/core/extensions/build_context_extensions.dart';
import 'package:mobile_template/core/utils/validation_utils.dart';
import 'package:mobile_template/core/utils/app_download.dart';
import 'package:mobile_template/features/auth/presentation/pages/login/bloc/login_bloc.dart';
import 'package:mobile_template/features/auth/presentation/widgets/auth_link_text.dart';
import 'package:mobile_template/features/auth/presentation/widgets/auth_scroll_scaffold.dart';
import 'package:mobile_template/features/auth/presentation/widgets/login_hero_section.dart';
import 'package:mobile_template/presentation/widgets/common/error_dialog.dart';
import 'package:mobile_template/presentation/widgets/common/global_button.dart';
import 'package:mobile_template/presentation/widgets/common/global_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_isLoading) return;
    if (_formKey.currentState!.validate()) {
      context.read<LoginBloc>().add(
        LoginSubmitted(
          email: _emailController.text.trim().toLowerCase(),
          password: _passwordController.text,
        ),
      );
    }
  }

  void _navigateToRegister() {
    context.push(AppRoutes.register);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dividerColor = theme.colorScheme.outline.withValues(alpha: 0.35);

    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) => _handleLoginState(state),
      builder: (context, state) {
        return AuthScrollScaffold(
          hero: LoginHeroSection(
            title: context.l10n.welcomeBack,
            subtitle: context.l10n.loginSubtitle,
            action: kIsWeb
                ? OutlinedButton.icon(
                    onPressed: downloadAndroidApp,
                    icon: const Icon(Icons.android),
                    label: Text(
                      context.l10n.downloadAndroidApp,
                      textAlign: TextAlign.center,
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white70),
                      minimumSize: const Size(0, 48),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                    ),
                  )
                : null,
          ),
          form: AutofillGroup(
            onDisposeAction: AutofillContextAction.cancel,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GlobalTextFormField(
                    controller: _emailController,
                    labelText: context.l10n.email,
                    hintText: context.l10n.emailHint,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [
                      AutofillHints.username,
                      AutofillHints.email,
                    ],
                    autocorrect: false,
                    enabled: !_isLoading,
                    validator: (value) =>
                        ValidationUtils.validateEmail(value, context),
                  ),
                  const SizedBox(height: AppDimensions.spaceL),
                  GlobalTextFormField(
                    controller: _passwordController,
                    labelText: context.l10n.password,
                    hintText: context.l10n.passwordHint,
                    obscureText: !_isPasswordVisible,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _handleLogin(),
                    autofillHints: const [AutofillHints.password],
                    autocorrect: false,
                    enableSuggestions: false,
                    enabled: !_isLoading,
                    suffixIcon: IconButton(
                      tooltip: _isPasswordVisible
                          ? context.l10n.hidePassword
                          : context.l10n.showPassword,
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                      onPressed: () => setState(
                        () => _isPasswordVisible = !_isPasswordVisible,
                      ),
                    ),
                    validator: (value) =>
                        ValidationUtils.validatePassword(value, context),
                  ),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: TextButton(
                      onPressed: _isLoading
                          ? null
                          : () => context.push(
                              AppRoutes.passwordReset,
                              extra: _emailController.text.trim().toLowerCase(),
                            ),
                      child: Text(context.l10n.forgotPassword),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spaceM),
                  GlobalButton(
                    text: context.l10n.signIn,
                    onPressed: _handleLogin,
                    isLoading: _isLoading,
                  ),
                  const SizedBox(height: AppDimensions.spaceXL),
                  Row(
                    children: [
                      Expanded(child: Divider(color: dividerColor)),
                      Padding(
                        padding: AppDimensions.paddingHorizontalM,
                        child: Text(
                          context.l10n.or,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: dividerColor)),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.spaceXL),
                  AuthLinkText(
                    normalText: context.l10n.dontHaveAccount,
                    linkText: context.l10n.signUp,
                    onTap: _navigateToRegister,
                    onGradient: false,
                  ),
                  const SizedBox(height: AppDimensions.spaceM),
                  TextButton(
                    onPressed: () => context.push(AppRoutes.privacy),
                    child: Text(context.l10n.privacyPolicy),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleLoginState(LoginState state) {
    if (state is LoginLoading) {
      setState(() => _isLoading = true);
    } else if (state is LoginSuccess) {
      setState(() => _isLoading = false);
      context.go(AppRoutes.home);
    } else if (state is LoginFailure) {
      setState(() => _isLoading = false);
      ErrorDialog.show(context, state.failure);
    }
  }
}
