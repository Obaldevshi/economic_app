import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_template/core/extensions/build_context_extensions.dart';

/// Public, shared mobile/web disclosure. No account or session is required.
class PrivacyPage extends StatefulWidget {
  const PrivacyPage({super.key});

  @override
  State<PrivacyPage> createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  late final Future<Map<String, dynamic>> _policy = rootBundle
      .loadString('assets/legal/privacy.json')
      .then((source) => jsonDecode(source) as Map<String, dynamic>);
  String? _language;

  @override
  Widget build(BuildContext context) {
    final language =
        _language ??
        (Localizations.localeOf(context).languageCode == 'ru' ? 'ru' : 'en');
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.privacyPolicy)),
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _policy,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text(context.l10n.error));
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final policy = snapshot.data!;
            final content = policy[language] as Map<String, dynamic>;
            final publisher = policy['publisher'] as String;
            final email = policy['supportEmail'] as String;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 760),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Wrap(
                        spacing: 12,
                        children: [
                          ChoiceChip(
                            label: const Text('Русский'),
                            selected: language == 'ru',
                            onSelected: (_) => setState(() => _language = 'ru'),
                          ),
                          ChoiceChip(
                            label: const Text('English'),
                            selected: language == 'en',
                            onSelected: (_) => setState(() => _language = 'en'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      SelectableText(
                        content['title'] as String,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 12),
                      SelectableText(policy['updated'] as String),
                      if (policy['publicationApproved'] != true) ...[
                        const SizedBox(height: 16),
                        SelectableText(content['draft'] as String),
                      ],
                      if (publisher.isNotEmpty && email.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        SelectableText('$publisher · $email'),
                      ],
                      for (final section in content['sections'] as List) ...[
                        const SizedBox(height: 28),
                        SelectableText(
                          section['title'] as String,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        SelectableText(section['text'] as String),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
