import 'package:mobile_template/core/errors/failure.dart';
import 'package:mobile_template/core/errors/failure_codes.dart';
import 'package:mobile_template/core/extensions/build_context_extensions.dart';
import 'package:flutter/material.dart';

extension FailureLocalization on Failure {
  String localizedMessage(BuildContext context) {
    if (message.isNotEmpty) return message;

    final l10n = context.l10n;
    return switch (errorCode) {
      FailureCodes.timeout => l10n.errorTimeout,
      FailureCodes.noInternet => l10n.offlineBanner,
      FailureCodes.requestCancelled => l10n.errorRequestCancelled,
      FailureCodes.invalidCredentials => l10n.errorInvalidCredentials,
      FailureCodes.accessForbidden => l10n.errorAccessDenied,
      FailureCodes.resourceNotFound => l10n.errorNotFound,
      FailureCodes.resourceExists => l10n.errorResourceExists,
      FailureCodes.validationFailed => l10n.errorValidation,
      FailureCodes.serverError => l10n.errorServer,
      _ => l10n.error,
    };
  }
}
