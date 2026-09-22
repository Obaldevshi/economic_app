import 'package:mobile_template/app/layout/app_layout_item_builder.dart';
import 'package:mobile_template/app/theme/app_dimensions.dart';
import 'package:mobile_template/core/extensions/build_context_extensions.dart';
import 'package:mobile_template/core/services/locale_service.dart';
import 'package:mobile_template/core/services/theme_service.dart';
import 'package:mobile_template/features/home/presentation/widgets/ui_kit_color_palette.dart';
import 'package:mobile_template/features/home/presentation/widgets/ui_kit_components_demo.dart';
import 'package:mobile_template/features/home/presentation/widgets/ui_kit_hero_banner.dart';
import 'package:mobile_template/features/home/presentation/widgets/ui_kit_tokens_demo.dart';
import 'package:mobile_template/features/home/presentation/widgets/ui_kit_typography_scale.dart';
import 'package:mobile_template/presentation/widgets/ui_kit/ui_kit_locale_switcher.dart';
import 'package:mobile_template/presentation/widgets/ui_kit/ui_kit_section_title.dart';
import 'package:mobile_template/presentation/widgets/ui_kit/ui_kit_theme_switcher.dart';
import 'package:mobile_template/presentation/widgets/layout/scroll_shell.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _demoInputController = TextEditingController();
  late final ThemeService _themeService = GetIt.instance<ThemeService>();
  late final LocaleService _localeService = GetIt.instance<LocaleService>();

  @override
  void dispose() {
    _demoInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ScrollShell(
      title: context.l10n.home,
      headerContent: Text(
        context.l10n.homeWelcome,
        style: theme.textTheme.bodyLarge?.copyWith(
          color: Colors.white.withValues(alpha: 0.9),
          fontWeight: FontWeight.w500,
        ),
      ),
      body: AppLayoutItemBuilder<Widget>(
        narrow: () => _buildNarrow(context),
        wide: () => AppLayoutItemBuilder<Widget>(
          narrow: () => _buildNarrow(context),
          wide: () => _buildWide(context),
        )(context, width: 900),
      )(context),
    );
  }

  Widget _buildNarrow(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const UiKitHeroBanner(),
        const SizedBox(height: AppDimensions.spaceL),
        _buildAppearance(context),
        const SizedBox(height: AppDimensions.spaceL),
        _buildColors(context),
        const SizedBox(height: AppDimensions.spaceL),
        _buildTypography(context),
        const SizedBox(height: AppDimensions.spaceL),
        _buildComponents(context),
        const SizedBox(height: AppDimensions.spaceL),
        _buildTokens(context),
      ],
    );
  }

  Widget _buildWide(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const UiKitHeroBanner(),
        const SizedBox(height: AppDimensions.spaceXL),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildAppearance(context)),
            const SizedBox(width: AppDimensions.spaceL),
            Expanded(child: _buildTypography(context)),
          ],
        ),
        const SizedBox(height: AppDimensions.spaceXL),
        _buildColors(context),
        const SizedBox(height: AppDimensions.spaceXL),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildComponents(context)),
            const SizedBox(width: AppDimensions.spaceL),
            Expanded(child: _buildTokens(context)),
          ],
        ),
      ],
    );
  }

  Widget _buildAppearance(BuildContext context, {bool showTitle = true}) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (showTitle)
            UiKitSectionTitle(title: context.l10n.homeSectionAppearance),
          UiKitThemeSwitcher(themeService: _themeService),
          const SizedBox(height: AppDimensions.spaceM),
          UiKitLocaleSwitcher(localeService: _localeService),
        ],
      );

  Widget _buildColors(BuildContext context, {bool showTitle = true}) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      if (showTitle) UiKitSectionTitle(title: context.l10n.homeSectionColors),
      const UiKitColorPalette(),
    ],
  );

  Widget _buildTypography(BuildContext context, {bool showTitle = true}) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (showTitle)
            UiKitSectionTitle(title: context.l10n.homeSectionTypography),
          const UiKitTypographyScale(),
        ],
      );

  Widget _buildComponents(BuildContext context, {bool showTitle = true}) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (showTitle)
            UiKitSectionTitle(title: context.l10n.homeSectionComponents),
          UiKitComponentsDemo(demoInputController: _demoInputController),
        ],
      );

  Widget _buildTokens(BuildContext context, {bool showTitle = true}) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      if (showTitle) UiKitSectionTitle(title: context.l10n.homeSectionTokens),
      const UiKitTokensDemo(),
    ],
  );
}
