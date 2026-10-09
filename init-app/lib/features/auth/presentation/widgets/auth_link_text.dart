import 'package:mobile_template/app/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class AuthLinkText extends StatelessWidget {
  const AuthLinkText({
    super.key,
    required this.normalText,
    required this.linkText,
    required this.onTap,
    this.onGradient = true,
  });

  final String normalText;
  final String linkText;
  final VoidCallback onTap;
  final bool onGradient;

  @override
  Widget build(BuildContext context) {
    final normalColor = onGradient
        ? Colors.white.withValues(alpha: 0.85)
        : Theme.of(context).colorScheme.onSurfaceVariant;
    final linkColor = onGradient
        ? Colors.white
        : Theme.of(context).colorScheme.primary;

    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 5,
      runSpacing: 4,
      children: [
        Text(
          normalText,
          style: AppTextStyles.bodyMedium.copyWith(color: normalColor),
        ),
        TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
            foregroundColor: linkColor,
            minimumSize: const Size(48, 48),
          ),
          child: Text(
            linkText,
            style: AppTextStyles.bodyMedium.copyWith(
              color: linkColor,
              fontWeight: FontWeight.w600,
              decoration: onGradient ? TextDecoration.underline : null,
              decorationColor: Colors.white.withValues(alpha: 0.6),
            ),
          ),
        ),
      ],
    );
  }
}
