import 'package:flutter/material.dart';
import 'package:mobile_template/core/di/di.dart';
import 'package:mobile_template/core/extensions/build_context_extensions.dart';
import 'package:mobile_template/core/services/offline_savings_service.dart';
import 'package:mobile_template/core/services/app_lock_service.dart';
import 'package:mobile_template/core/errors/failure.dart';
import 'package:mobile_template/presentation/widgets/common/error_dialog.dart';
import 'package:mobile_template/presentation/widgets/common/confirmation_dialog.dart';

class SyncStatusStrip extends StatelessWidget {
  const SyncStatusStrip({required this.onLogin, super.key});
  final VoidCallback onLogin;
  @override
  Widget build(BuildContext context) {
    final service = getIt<OfflineSavingsService>(),
        lock = getIt<AppLockService>();
    return ListenableBuilder(
      listenable: Listenable.merge([service, lock]),
      builder: (context, _) {
        if (!service.enabled ||
            !service.hasAccount ||
            !lock.accessible ||
            (!service.offline &&
                service.pendingCount == 0 &&
                service.issue == null &&
                !service.syncing)) {
          return const SizedBox.shrink();
        }
        final l = context.l10n, scheme = Theme.of(context).colorScheme;
        final text = service.problemStatus != null
            ? l.syncConflict
            : service.issue == 'storage'
            ? l.offlineStorageError
            : service.needsLogin && service.hasLocalChanges
            ? l.syncLogin
            : service.pendingCount > 0
            ? l.syncPending(service.pendingCount)
            : service.syncing
            ? l.syncInProgress
            : l.offlineAvailable;
        return Material(
          color: scheme.surfaceContainerHighest,
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Icon(
                        service.problemStatus != null
                            ? Icons.info_outline
                            : service.offline
                            ? Icons.cloud_off_outlined
                            : Icons.sync,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          text,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      Flexible(
                        child: TextButton(
                          onPressed: service.syncing
                              ? null
                              : service.needsLogin
                              ? onLogin
                              : () => service.sync(force: true),
                          child: Text(
                            service.needsLogin ? l.signIn : l.syncNow,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (service.problemStatus != null)
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        if (service.problemStatus == 409)
                          TextButton(
                            onPressed: () async {
                              if (await ConfirmationDialog.show(
                                    context,
                                    title: l.syncKeepLocal,
                                    content: l.syncOverwriteWarning,
                                    confirmText: l.syncKeepLocal,
                                  ) ==
                                  true) {
                                try {
                                  await service.keepLocalVersion();
                                } catch (_) {
                                  if (context.mounted) {
                                    ErrorDialog.show(
                                      context,
                                      const CacheFailure(
                                        message: 'Offline storage unavailable',
                                      ),
                                    );
                                  }
                                }
                              }
                            },
                            child: Text(l.syncKeepLocal),
                          ),
                        TextButton(
                          onPressed: () async {
                            if (await ConfirmationDialog.show(
                                  context,
                                  title: l.syncKeepServer,
                                  content: l.syncDiscardWarning,
                                  confirmText: l.syncKeepServer,
                                  isDestructive: true,
                                ) ==
                                true) {
                              try {
                                await service.discardProblem();
                              } catch (_) {
                                if (context.mounted) {
                                  ErrorDialog.show(
                                    context,
                                    const CacheFailure(
                                      message: 'Offline storage unavailable',
                                    ),
                                  );
                                }
                              }
                            }
                          },
                          child: Text(l.syncKeepServer),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
