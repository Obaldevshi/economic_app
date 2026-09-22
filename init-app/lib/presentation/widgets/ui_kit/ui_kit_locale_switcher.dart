import 'package:mobile_template/core/extensions/build_context_extensions.dart';
import 'package:mobile_template/core/services/locale_service.dart';
import 'package:mobile_template/presentation/widgets/common/glass_surface_card.dart';
import 'package:mobile_template/presentation/widgets/ui_kit/ui_kit_segmented_control.dart';
import 'package:flutter/material.dart';

enum _LocaleChoice { system, en, ru }

class UiKitLocaleSwitcher extends StatelessWidget {
  const UiKitLocaleSwitcher({required this.localeService, super.key});

  final LocaleService localeService;

  _LocaleChoice _fromLocale(Locale? locale) {
    if (locale == null) return _LocaleChoice.system;
    if (locale.languageCode == 'ru') return _LocaleChoice.ru;
    return _LocaleChoice.en;
  }

  Future<void> _onSelected(_LocaleChoice choice) {
    return switch (choice) {
      _LocaleChoice.system => localeService.setLocale(null),
      _LocaleChoice.en => localeService.setLocale(const Locale('en')),
      _LocaleChoice.ru => localeService.setLocale(const Locale('ru')),
    };
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: localeService,
      builder: (context, _) {
        return GlassSurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.language_rounded,
                    size: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    context.l10n.language,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              UiKitSegmentedControl<_LocaleChoice>(
                selected: _fromLocale(localeService.locale),
                onSelected: _onSelected,
                options: [
                  UiKitSegmentOption(
                    value: _LocaleChoice.system,
                    label: context.l10n.languageSystem,
                    icon: Icons.settings_suggest_rounded,
                  ),
                  const UiKitSegmentOption(
                    value: _LocaleChoice.en,
                    label: 'EN',
                    icon: Icons.translate_rounded,
                  ),
                  const UiKitSegmentOption(
                    value: _LocaleChoice.ru,
                    label: 'RU',
                    icon: Icons.translate_rounded,
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
