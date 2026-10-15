import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_template/app/app_router.dart';
import 'package:mobile_template/app/theme/app_dimensions.dart';
import 'package:mobile_template/core/extensions/build_context_extensions.dart';
import 'package:mobile_template/core/extensions/failure_extensions.dart';
import 'package:mobile_template/core/utils/validation_utils.dart';
import 'package:mobile_template/features/auth/presentation/pages/password_reset/bloc/password_reset_bloc.dart';
import 'package:mobile_template/features/auth/presentation/widgets/auth_scroll_scaffold.dart';
import 'package:mobile_template/features/auth/presentation/widgets/login_hero_section.dart';
import 'package:mobile_template/presentation/widgets/common/global_button.dart';
import 'package:mobile_template/presentation/widgets/common/global_text_form_field.dart';

class PasswordResetPage extends StatefulWidget {
  const PasswordResetPage({this.initialEmail = '', super.key});
  final String initialEmail;
  @override
  State<PasswordResetPage> createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  final _form = GlobalKey<FormState>();
  late final _email = TextEditingController(text: widget.initialEmail);
  final _code = TextEditingController();
  final _password = TextEditingController();
  final _confirmation = TextEditingController();
  Timer? _timer;
  bool _showPassword = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      final state = context.read<PasswordResetBloc>().state;
      if (state.codeRequested && !state.completed && state.resendAt != null) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _email.dispose();
    _code.dispose();
    _password.dispose();
    _confirmation.dispose();
    super.dispose();
  }

  void _backToLogin() => context.go('${AppRoutes.login}?reauth=true');

  void _submit() {
    final bloc = context.read<PasswordResetBloc>();
    if (bloc.state.busy || !_form.currentState!.validate()) {
      return;
    }
    final email = _email.text.trim().toLowerCase();
    if (!bloc.state.codeRequested) {
      _requestCode(email);
    } else {
      bloc.add(ConfirmPasswordReset(email, _code.text.trim(), _password.text));
    }
  }

  void _requestCode(String email) {
    final language = Localizations.localeOf(context).languageCode;
    context.read<PasswordResetBloc>().add(
      RequestPasswordResetCode(email, language),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) => BlocConsumer<PasswordResetBloc, PasswordResetState>(
    listenWhen: (a, b) => !a.completed && b.completed,
    listener: (context, state) {
      _timer?.cancel();
      _code.clear();
      _password.clear();
      _confirmation.clear();
    },
    builder: (context, state) {
      final seconds = state.resendAt == null
          ? 0
          : (state.resendAt!.difference(DateTime.now()).inMilliseconds / 1000)
                .ceil()
                .clamp(0, 60)
                .toInt();
      return PopScope(
        canPop: !state.busy,
        child: AuthScrollScaffold(
          hero: LoginHeroSection(
            title: context.l10n.resetPasswordTitle,
            subtitle: context.l10n.resetPasswordDescription,
            showBackButton: true,
            onBackPressed: state.busy ? () {} : _backToLogin,
          ),
          form: state.completed
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(
                      Icons.check_circle_outline_rounded,
                      size: 56,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: AppDimensions.spaceL),
                    Text(
                      context.l10n.resetPasswordSuccess,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: AppDimensions.spaceM),
                    Text(context.l10n.resetPasswordSuccessHint),
                    const SizedBox(height: AppDimensions.spaceL),
                    GlobalButton(
                      text: context.l10n.signIn,
                      onPressed: _backToLogin,
                    ),
                  ],
                )
              : AutofillGroup(
                  onDisposeAction: AutofillContextAction.cancel,
                  child: Form(
                    key: _form,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (!state.codeRequested)
                          GlobalTextFormField(
                            key: const ValueKey('reset-email'),
                            controller: _email,
                            labelText: context.l10n.email,
                            maxLength: 254,
                            keyboardType: TextInputType.emailAddress,
                            enabled: !state.busy,
                            autocorrect: false,
                            autofillHints: const [AutofillHints.email],
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _submit(),
                            validator: (v) => ValidationUtils.validateEmail(
                              v?.trim(),
                              context,
                            ),
                          )
                        else ...[
                          Text(
                            context.l10n.resetCodeNotice(_email.text.trim()),
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: AppDimensions.spaceL),
                          GlobalTextFormField(
                            key: const ValueKey('reset-code'),
                            controller: _code,
                            labelText: context.l10n.resetCodeLabel,
                            hintText: context.l10n.resetCodeHint,
                            maxLength: 6,
                            enabled: !state.busy,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.oneTimeCode],
                            validator: (v) =>
                                RegExp(r'^[0-9]{6}$').hasMatch(v ?? '')
                                ? null
                                : context.l10n.resetCodeFormat,
                          ),
                          const SizedBox(height: AppDimensions.spaceM),
                          GlobalTextFormField(
                            key: const ValueKey('reset-password'),
                            controller: _password,
                            labelText: context.l10n.newPassword,
                            obscureText: !_showPassword,
                            enabled: !state.busy,
                            autocorrect: false,
                            enableSuggestions: false,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.newPassword],
                            suffixIcon: IconButton(
                              tooltip: _showPassword
                                  ? context.l10n.hidePassword
                                  : context.l10n.showPassword,
                              onPressed: state.busy
                                  ? null
                                  : () => setState(
                                      () => _showPassword = !_showPassword,
                                    ),
                              icon: Icon(
                                _showPassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                              ),
                            ),
                            validator: (v) =>
                                ValidationUtils.validatePassword(v, context) ??
                                (utf8.encode(v ?? '').length > 72
                                    ? context.l10n.resetPasswordByteLimit
                                    : null),
                          ),
                          const SizedBox(height: AppDimensions.spaceM),
                          GlobalTextFormField(
                            key: const ValueKey('reset-confirm'),
                            controller: _confirmation,
                            labelText: context.l10n.confirmNewPassword,
                            obscureText: !_showPassword,
                            enabled: !state.busy,
                            autocorrect: false,
                            enableSuggestions: false,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _submit(),
                            validator: (v) =>
                                v == _password.text && (v?.isNotEmpty ?? false)
                                ? null
                                : context.l10n.passwordsDontMatch,
                          ),
                        ],
                        if (state.failure != null) ...[
                          const SizedBox(height: AppDimensions.spaceM),
                          Semantics(
                            liveRegion: true,
                            child: Text(
                              state.failure!.localizedMessage(context),
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                            ),
                          ),
                        ],
                        const SizedBox(height: AppDimensions.spaceL),
                        GlobalButton(
                          text: state.codeRequested
                              ? context.l10n.resetPasswordSubmit
                              : context.l10n.sendResetCode,
                          onPressed: _submit,
                          isLoading: state.busy,
                        ),
                        if (state.codeRequested) ...[
                          const SizedBox(height: AppDimensions.spaceS),
                          TextButton(
                            onPressed: state.busy || seconds > 0
                                ? null
                                : () {
                                    _code.clear();
                                    _requestCode(
                                      _email.text.trim().toLowerCase(),
                                    );
                                  },
                            child: Text(
                              seconds > 0
                                  ? context.l10n.resetResendCountdown(seconds)
                                  : context.l10n.resetResendCode,
                            ),
                          ),
                          TextButton(
                            onPressed: state.busy
                                ? null
                                : () {
                                    _code.clear();
                                    _password.clear();
                                    _confirmation.clear();
                                    context.read<PasswordResetBloc>().add(
                                      const ChangePasswordResetEmail(),
                                    );
                                  },
                            child: Text(context.l10n.resetChangeEmail),
                          ),
                        ],
                        TextButton(
                          onPressed: state.busy ? null : _backToLogin,
                          child: Text(context.l10n.resetBackLogin),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      );
    },
  );
}
