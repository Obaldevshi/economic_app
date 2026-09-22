import 'package:mobile_template/app/theme/app_colors.dart';
import 'package:mobile_template/app/theme/app_dimensions.dart';
import 'package:mobile_template/core/extensions/build_context_extensions.dart';
import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmText;
  final String? cancelText;
  final bool isDestructive;
  final VoidCallback? onConfirm;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.content,
    required this.confirmText,
    this.cancelText,
    this.isDestructive = true,
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: AppDimensions.paddingAllL,
      child: Padding(
        padding: AppDimensions.paddingAllL,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: AppDimensions.spaceM),
            Text(
              content,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppDimensions.spaceL),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(cancelText ?? context.l10n.cancel),
                ),
                const SizedBox(width: AppDimensions.spaceS),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    onConfirm?.call();
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: isDestructive
                        ? AppColors.error
                        : AppColors.primary,
                  ),
                  child: Text(confirmText),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Show confirmation dialog and return the result
  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String content,
    required String confirmText,
    String? cancelText,
    bool isDestructive = true,
    VoidCallback? onConfirm,
  }) {
    return showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.32),
      builder: (context) => ConfirmationDialog(
        title: title,
        content: content,
        confirmText: confirmText,
        cancelText: cancelText,
        isDestructive: isDestructive,
        onConfirm: onConfirm,
      ),
    );
  }
}
