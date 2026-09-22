import 'package:mobile_template/app/layout/app_layout_item_builder.dart';
import 'package:mobile_template/app/theme/app_dimensions.dart';
import 'package:mobile_template/core/extensions/build_context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginHeroSection extends StatelessWidget {
  const LoginHeroSection({
    required this.title,
    required this.subtitle,
    this.showBackButton = false,
    this.onBackPressed,
    super.key,
  });

  final String title;
  final String subtitle;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isWide = AppLayoutItemBuilder<bool>.values(narrow: false, wide: true)(
      context,
    );

    return Padding(
      padding: isWide
          ? AppDimensions.paddingAllXL
          : EdgeInsets.fromLTRB(
              AppDimensions.paddingL,
              showBackButton ? AppDimensions.paddingS : AppDimensions.paddingXL,
              AppDimensions.paddingL,
              AppDimensions.paddingL,
            ),
      child: Column(
        crossAxisAlignment: isWide
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          if (showBackButton)
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: onBackPressed ?? () => context.pop(),
                icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
              ),
            ),
          Text(
            context.l10n.appName,
            style: theme.textTheme.headlineLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
            textAlign: isWide ? TextAlign.left : TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.spaceL),
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
            textAlign: isWide ? TextAlign.left : TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.spaceS),
          Text(
            subtitle,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.88),
            ),
            textAlign: isWide ? TextAlign.left : TextAlign.center,
          ),
        ],
      ),
    );
  }
}
