import 'package:mobile_template/app/app_router.dart';
import 'package:mobile_template/app/layout/app_layout_item_builder.dart';
import 'package:mobile_template/app/theme/app_colors.dart';
import 'package:mobile_template/app/theme/app_dimensions.dart';
import 'package:mobile_template/app/theme/app_text_styles.dart';
import 'package:mobile_template/core/di/di.dart';
import 'package:mobile_template/core/extensions/build_context_extensions.dart';
import 'package:mobile_template/core/services/session_service.dart';
import 'package:mobile_template/core/utils/package_info_utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final sessionService = getIt<SessionService>();
      context.go(
        sessionService.isLoggedIn() ? AppRoutes.home : AppRoutes.login,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        Text(
          context.l10n.appName,
          style: AppTextStyles.displayMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDimensions.spaceS),
        Text(
          context.l10n.appTagline,
          style: AppTextStyles.bodyLarge.copyWith(
            color: Colors.white.withValues(alpha: 0.9),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDimensions.spaceXL),
        const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
        const Spacer(),
        FutureBuilder(
          future: PackageInfoUtils.appVersion(),
          builder: (context, snapshot) => Text(
            'v${snapshot.data ?? ''}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.spaceM),
      ],
    );

    return Scaffold(
      body: Container(
        color: AppColors.primary,
        child: SafeArea(
          child: AppLayoutItemBuilder<Widget>(
            narrow: () => Padding(
              padding: AppDimensions.paddingHorizontalL,
              child: content,
            ),
            wide: () => Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: SizedBox(width: double.infinity, child: content),
              ),
            ),
          )(context),
        ),
      ),
    );
  }
}
