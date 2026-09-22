import 'package:mobile_template/core/extensions/build_context_extensions.dart';
import 'package:mobile_template/core/services/theme_service.dart';
import 'package:mobile_template/presentation/widgets/common/glass_surface_card.dart';
import 'package:mobile_template/presentation/widgets/ui_kit/ui_kit_segmented_control.dart';
import 'package:flutter/material.dart';

class UiKitThemeSwitcher extends StatelessWidget {
  const UiKitThemeSwitcher({required this.themeService, super.key});

  final ThemeService themeService;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeService,
      builder: (context, _) {
        return GlassSurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.palette_outlined,
                    size: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    context.l10n.appearance,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              UiKitSegmentedControl<ThemeMode>(
                selected: themeService.themeMode,
                onSelected: themeService.setThemeMode,
                options: [
                  UiKitSegmentOption(
                    value: ThemeMode.system,
                    label: context.l10n.themeSystem,
                    icon: Icons.brightness_auto_rounded,
                  ),
                  UiKitSegmentOption(
                    value: ThemeMode.light,
                    label: context.l10n.themeLight,
                    icon: Icons.light_mode_rounded,
                  ),
                  UiKitSegmentOption(
                    value: ThemeMode.dark,
                    label: context.l10n.themeDark,
                    icon: Icons.dark_mode_rounded,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
