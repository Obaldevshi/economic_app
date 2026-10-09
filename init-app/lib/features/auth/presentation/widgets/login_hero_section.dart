import 'package:mobile_template/app/layout/app_layout_item_builder.dart';
import 'package:mobile_template/app/theme/app_dimensions.dart';
import 'package:mobile_template/core/extensions/build_context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_template/app/theme/app_colors.dart';
import 'package:mobile_template/presentation/widgets/common/brand_mark.dart';
import 'package:mobile_template/presentation/widgets/common/language_selector.dart';

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
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: isWide
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          const Align(
            alignment: AlignmentDirectional.centerEnd,
            child: LanguageSelector(onDark: true),
          ),
          if (showBackButton)
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: IconButton(
                onPressed: onBackPressed ?? () => context.pop(),
                icon: const BackButtonIcon(),
                color: Colors.white,
              ),
            ),
          Align(
            alignment: isWide
                ? AlignmentDirectional.centerStart
                : Alignment.center,
            child: const BrandMark(size: 60, onDark: true),
          ),
          const SizedBox(height: AppDimensions.spaceL),
          Text(
            context.l10n.appName,
            style: theme.textTheme.displaySmall?.copyWith(color: Colors.white),
            textAlign: isWide ? TextAlign.start : TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.spaceL),
          Align(
            alignment: isWide
                ? AlignmentDirectional.centerStart
                : Alignment.center,
            child: Container(width: 44, height: 2, color: AppColors.accent),
          ),
          const SizedBox(height: AppDimensions.spaceL),
          Text(
            title,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: Colors.white,
            ),
            textAlign: isWide ? TextAlign.start : TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.spaceS),
          Text(
            subtitle,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.88),
            ),
            textAlign: isWide ? TextAlign.start : TextAlign.center,
          ),
        ],
      ),
    );
  }
}
