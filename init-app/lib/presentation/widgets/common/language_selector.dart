import 'package:flutter/material.dart';
import 'package:mobile_template/core/di/di.dart';
import 'package:mobile_template/core/extensions/build_context_extensions.dart';
import 'package:mobile_template/core/services/app_languages.dart';
import 'package:mobile_template/core/services/locale_service.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({this.onDark = false, this.localeService, super.key});
  final bool onDark;
  final LocaleService? localeService;
  @override
  Widget build(BuildContext context) {
    final service = localeService ?? getIt<LocaleService>();
    return ListenableBuilder(
      listenable: service,
      builder: (context, _) {
        final selected = AppLanguage.find(service.locale);
        final color = onDark
            ? Colors.white
            : Theme.of(context).colorScheme.onSurface;
        return PopupMenuButton<String>(
          tooltip: context.l10n.chooseLanguage,
          initialValue: selected?.code ?? '',
          onSelected: (code) =>
              service.setLocale(code.isEmpty ? null : Locale(code)),
          itemBuilder: (context) => [
            PopupMenuItem(value: '', child: Text(context.l10n.languageSystem)),
            for (final language in AppLanguage.all)
              PopupMenuItem(
                value: language.code,
                child: Row(
                  children: [
                    Expanded(child: Text(language.name)),
                    if (language.code == selected?.code)
                      const Icon(Icons.check_rounded, size: 20),
                  ],
                ),
              ),
          ],
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.language_rounded, size: 20, color: color),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    selected?.name ?? context.l10n.chooseLanguage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: color),
                  ),
                ),
                Icon(Icons.expand_more_rounded, size: 20, color: color),
              ],
            ),
          ),
        );
      },
    );
  }
}
