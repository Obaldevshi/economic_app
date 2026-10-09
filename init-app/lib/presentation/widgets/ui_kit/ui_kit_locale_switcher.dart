import 'package:flutter/material.dart';
import 'package:mobile_template/core/extensions/build_context_extensions.dart';
import 'package:mobile_template/core/services/locale_service.dart';
import 'package:mobile_template/presentation/widgets/common/glass_surface_card.dart';
import 'package:mobile_template/presentation/widgets/common/language_selector.dart';

class UiKitLocaleSwitcher extends StatelessWidget {
  const UiKitLocaleSwitcher({required this.localeService, super.key});
  final LocaleService localeService;
  @override
  Widget build(BuildContext context) => GlassSurfaceCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.language,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        LanguageSelector(localeService: localeService),
        const SizedBox(height: 8),
        Text(
          context.l10n.coinLanguageHint,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    ),
  );
}
