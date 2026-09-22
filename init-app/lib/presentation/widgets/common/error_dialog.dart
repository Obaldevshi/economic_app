import 'package:mobile_template/app/theme/app_colors.dart';
import 'package:mobile_template/app/theme/app_dimensions.dart';
import 'package:mobile_template/app/theme/app_text_styles.dart';
import 'package:mobile_template/core/errors/failure.dart';
import 'package:mobile_template/core/extensions/build_context_extensions.dart';
import 'package:mobile_template/core/extensions/failure_extensions.dart';
import 'package:mobile_template/presentation/widgets/common/global_button.dart';
import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final Failure failure;

  const ErrorDialog({super.key, required this.failure});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: AppDimensions.paddingAllL,
      child: Padding(
        padding: AppDimensions.paddingAllL,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getIconForStatusCode(failure.statusCode),
              size: 56,
              color: _getColorForStatusCode(failure.statusCode),
            ),
            const SizedBox(height: AppDimensions.spaceL),
            Text(
              _getTitleForStatusCode(context, failure.statusCode),
              style: AppTextStyles.headlineSmall.copyWith(
                color: _getColorForStatusCode(failure.statusCode),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spaceM),
            Text(
              failure.localizedMessage(context),
              style: AppTextStyles.bodyMedium.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spaceL),
            GlobalButton(
              text: context.l10n.ok,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForStatusCode(int? statusCode) {
    if (statusCode == null) return Icons.error_outline;

    switch (statusCode) {
      case 400:
        return Icons.warning_amber_outlined;
      case 401:
        return Icons.lock_outline;
      case 403:
        return Icons.block_outlined;
      case 404:
        return Icons.search_off_outlined;
      case 408:
        return Icons.access_time_outlined;
      case 422:
        return Icons.error_outline;
      case 429:
        return Icons.speed_outlined;
      case 500:
      case 502:
      case 503:
      case 504:
        return Icons.dns_outlined;
      default:
        if (statusCode >= 400 && statusCode < 500) {
          return Icons.warning_amber_outlined;
        } else if (statusCode >= 500) {
          return Icons.dns_outlined;
        }
        return Icons.error_outline;
    }
  }

  Color _getColorForStatusCode(int? statusCode) {
    if (statusCode == null) return AppColors.error;

    switch (statusCode) {
      case 400:
      case 422:
        return AppColors.warning;
      case 401:
      case 403:
        return AppColors.error;
      case 404:
        return AppColors.info;
      case 408:
      case 429:
        return AppColors.warning;
      case 500:
      case 502:
      case 503:
      case 504:
        return AppColors.error;
      default:
        if (statusCode >= 400 && statusCode < 500) {
          return AppColors.warning;
        } else if (statusCode >= 500) {
          return AppColors.error;
        }
        return AppColors.error;
    }
  }

  String _getTitleForStatusCode(BuildContext context, int? statusCode) {
    final l10n = context.l10n;
    if (statusCode == null) return l10n.error;

    switch (statusCode) {
      case 400:
        return l10n.errorBadRequest;
      case 401:
        return l10n.errorUnauthorized;
      case 403:
        return l10n.errorAccessDenied;
      case 404:
        return l10n.errorNotFound;
      case 408:
        return l10n.errorTimeout;
      case 422:
        return l10n.errorValidation;
      case 429:
        return l10n.errorTooManyRequests;
      case 500:
        return l10n.errorServer;
      case 502:
        return l10n.errorBadGateway;
      case 503:
        return l10n.errorServiceUnavailable;
      case 504:
        return l10n.errorGatewayTimeout;
      default:
        if (statusCode >= 400 && statusCode < 500) {
          return l10n.errorClient;
        } else if (statusCode >= 500) {
          return l10n.errorServer;
        }
        return l10n.error;
    }
  }

  static void show(BuildContext context, Failure failure) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.32),
      builder: (context) => ErrorDialog(failure: failure),
    );
  }
}
