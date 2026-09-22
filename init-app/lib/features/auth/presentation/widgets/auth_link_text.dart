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

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          normalText,
          style: AppTextStyles.bodyMedium.copyWith(color: normalColor),
        ),
        SizedBox(width: 5),
        GestureDetector(
          onTap: onTap,
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
