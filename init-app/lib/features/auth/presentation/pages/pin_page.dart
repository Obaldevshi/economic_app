import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_template/core/di/di.dart';
import 'package:mobile_template/core/extensions/build_context_extensions.dart';
import 'package:mobile_template/core/services/app_lock_service.dart';
import 'package:mobile_template/core/services/session_service.dart';
import 'package:mobile_template/features/auth/presentation/widgets/auth_scroll_scaffold.dart';
import 'package:mobile_template/features/auth/presentation/widgets/login_hero_section.dart';

class PinPage extends StatefulWidget {
  const PinPage({super.key});
  @override
  State<PinPage> createState() => _PinPageState();
}

class _PinPageState extends State<PinPage> {
  final _pin = TextEditingController();
  final _lock = getIt<AppLockService>();
  Timer? _timer;
  String? _first, _error;
  bool _busy = false;
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pin.clear();
    _pin.dispose();
    _first = null;
    super.dispose();
  }

  Future<void> _submit() async {
    if (_busy || _lock.retryAfter > Duration.zero) return;
    final value = _pin.text;
    if (!RegExp(r'^\d{4}$').hasMatch(value)) {
      setState(() => _error = context.l10n.pinFourDigits);
      return;
    }
    final setup = _lock.prompt && !_lock.locked;
    _pin.clear();
    if (setup && _first == null) {
      setState(() {
        _first = value;
        _error = null;
      });
      return;
    }
    if (setup && value != _first) {
      setState(() {
        _first = null;
        _error = context.l10n.pinMismatch;
      });
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      if (setup) {
        await _lock.setPin(value);
      } else if (!await _lock.unlock(value) && mounted) {
        setState(() => _error = context.l10n.pinIncorrect);
      }
    } catch (_) {
      if (mounted) setState(() => _error = context.l10n.pinStorageError);
    } finally {
      _first = null;
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: _lock,
    builder: (context, _) {
      if (_lock.loading) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }
      final setup = _lock.prompt && !_lock.locked;
      return AuthScrollScaffold(
        hero: LoginHeroSection(
          title: setup ? context.l10n.pinCreate : context.l10n.pinEnter,
          subtitle: context.l10n.pinHint,
        ),
        form: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              setup && _first != null
                  ? context.l10n.pinConfirm
                  : setup
                  ? context.l10n.pinCreate
                  : context.l10n.pinEnter,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            TextField(
              key: ValueKey('${setup}_${_first != null}'),
              controller: _pin,
              autofocus: true,
              obscureText: true,
              autocorrect: false,
              enableSuggestions: false,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4),
              ],
              enabled: !_busy && _lock.retryAfter == Duration.zero,
              decoration: InputDecoration(
                labelText: context.l10n.pinFourDigits,
                errorText:
                    _error ??
                    (_lock.storageError ? context.l10n.pinStorageError : null),
              ),
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 16),
            if (_lock.retryAfter > Duration.zero)
              Text(context.l10n.pinWait(_lock.retryAfter.inSeconds + 1)),
            FilledButton(
              onPressed: _busy || _lock.retryAfter > Duration.zero
                  ? null
                  : _submit,
              child: _busy
                  ? const SizedBox.square(
                      dimension: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(context.l10n.continueAction),
            ),
            const SizedBox(height: 12),
            if (setup)
              TextButton(
                onPressed: _busy
                    ? null
                    : () async {
                        try {
                          await _lock.cancelSetup();
                        } catch (_) {
                          if (mounted) {
                            setState(
                              () => _error = context.l10n.pinStorageError,
                            );
                          }
                        }
                      },
                child: Text(context.l10n.pinLater),
              )
            else
              TextButton(
                onPressed: _busy ? null : _lock.usePassword,
                child: Text(context.l10n.pinUsePassword),
              ),
            TextButton(
              onPressed: _busy
                  ? null
                  : () => getIt<SessionService>().clearSession(),
              child: Text(context.l10n.logout),
            ),
          ],
        ),
      );
    },
  );
}
