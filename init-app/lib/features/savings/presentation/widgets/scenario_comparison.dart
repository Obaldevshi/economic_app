import 'package:flutter/material.dart';
import 'package:mobile_template/app/theme/app_dimensions.dart';
import 'package:mobile_template/core/extensions/build_context_extensions.dart';
import 'package:mobile_template/data/models/response/savings_response.dart';
import 'package:mobile_template/features/savings/presentation/widgets/savings_ui.dart';
import 'package:mobile_template/presentation/widgets/common/glass_surface_card.dart';

class ScenarioComparison extends StatefulWidget {
  const ScenarioComparison({
    required this.items,
    required this.rate,
    super.key,
  });
  final List<ImpulseItemResponse> items;
  final double rate;
  @override
  State<ScenarioComparison> createState() => _ScenarioComparisonState();
}

class _ScenarioComparisonState extends State<ScenarioComparison> {
  int? _itemId;
  int _baseline = 7;
  int _moderate = 3;
  int _minimal = 1;
  final _moderateScroll = ScrollController();
  final _minimalScroll = ScrollController();

  @override
  void dispose() {
    _moderateScroll.dispose();
    _minimalScroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) return const SizedBox.shrink();
    final item =
        widget.items.where((item) => item.id == _itemId).firstOrNull ??
        widget.items.first;
    return GlassSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.l10n.scenarioComparison,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppDimensions.spaceM),
          DropdownButtonFormField<int>(
            key: ValueKey(item.id),
            initialValue: item.id,
            isExpanded: true,
            decoration: InputDecoration(labelText: context.l10n.impulseItem),
            items: widget.items
                .map(
                  (value) => DropdownMenuItem(
                    value: value.id,
                    child: Text(value.name, overflow: TextOverflow.ellipsis),
                  ),
                )
                .toList(),
            onChanged: (value) => setState(() => _itemId = value),
          ),
          const SizedBox(height: AppDimensions.spaceS),
          Text(
            context.l10n.scenarioPrice(
              formatRubles(context, item.defaultAmount),
              formatRate(context, widget.rate),
            ),
          ),
          _frequency(
            context.l10n.scenarioBaseline,
            _baseline,
            (value) => setState(() {
              _baseline = value;
              if (_moderate > value) _moderate = value;
              if (_minimal > value) _minimal = value;
            }),
            50,
          ),
          _frequency(
            context.l10n.scenarioModerate,
            _moderate,
            (value) => setState(() => _moderate = value),
            _baseline,
          ),
          _frequency(
            context.l10n.scenarioMinimal,
            _minimal,
            (value) => setState(() => _minimal = value),
            _baseline,
          ),
          const SizedBox(height: AppDimensions.spaceM),
          for (final scenario in [
            (context.l10n.scenarioModerate, _moderate, _moderateScroll),
            (context.l10n.scenarioMinimal, _minimal, _minimalScroll),
          ]) ...[
            Text(
              context.l10n.scenarioFrequency(scenario.$1, scenario.$2),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Scrollbar(
              controller: scenario.$3,
              thumbVisibility: true,
              child: SingleChildScrollView(
                controller: scenario.$3,
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text(context.l10n.projectionTableYear)),
                    DataColumn(
                      label: Text(context.l10n.scenarioOwnMoney),
                      numeric: true,
                    ),
                    DataColumn(
                      label: Text(context.l10n.compoundEffect),
                      numeric: true,
                    ),
                    DataColumn(
                      label: Text(context.l10n.projectionTableTotal),
                      numeric: true,
                    ),
                  ],
                  rows: [
                    for (final years in [1, 5, 10])
                      _row(context, item, scenario.$2, years),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.spaceM),
          ],
          Text(
            context.l10n.scenarioAssumptions,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _frequency(
    String label,
    int value,
    ValueChanged<int> onChanged,
    int max,
  ) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(context.l10n.scenarioFrequency(label, value)),
      Slider(
        value: value.toDouble(),
        min: 0,
        max: max == 0 ? 1 : max.toDouble(),
        divisions: max == 0 ? 1 : max,
        label: '$value',
        semanticFormatterCallback: (value) =>
            context.l10n.scenarioFrequency(label, value.round()),
        onChanged: max == 0 ? null : (value) => onChanged(value.round()),
      ),
    ],
  );

  DataRow _row(
    BuildContext context,
    ImpulseItemResponse item,
    int frequency,
    int years,
  ) {
    final annual = (_baseline - frequency) * 52 * item.defaultAmount;
    final own = annual * years;
    final total = widget.rate == 0
        ? own
        : regularSkipsFutureValue(annual, widget.rate, years);
    return DataRow(
      cells: [
        DataCell(Text('$years')),
        DataCell(Text(formatRubles(context, own))),
        DataCell(Text(formatRubles(context, total - own))),
        DataCell(Text(formatRubles(context, total))),
      ],
    );
  }
}
