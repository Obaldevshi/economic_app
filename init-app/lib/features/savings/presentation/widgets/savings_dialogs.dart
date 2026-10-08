import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:mobile_template/app/theme/app_dimensions.dart';
import 'package:mobile_template/core/extensions/build_context_extensions.dart';
import 'package:mobile_template/data/models/request/savings_request.dart';
import 'package:mobile_template/data/models/response/savings_response.dart';
import 'package:mobile_template/features/savings/presentation/pages/bloc/savings_bloc.dart';
import 'package:mobile_template/features/savings/presentation/widgets/savings_ui.dart';
import 'package:mobile_template/presentation/widgets/common/global_text_form_field.dart';

Future<void> showAddSavingDialog(
  BuildContext context,
  List<ImpulseItemResponse> impulses, {
  ImpulseItemResponse? initialImpulse,
}) => showDialog<void>(
  context: context,
  builder: (_) => BlocProvider.value(
    value: context.read<SavingsBloc>(),
    child: _AddSavingDialog(
      impulses: impulses.where((item) => item.isActive).toList(),
      initialImpulse: initialImpulse,
    ),
  ),
);

class _AddSavingDialog extends StatefulWidget {
  const _AddSavingDialog({required this.impulses, this.initialImpulse});
  final List<ImpulseItemResponse> impulses;
  final ImpulseItemResponse? initialImpulse;

  @override
  State<_AddSavingDialog> createState() => _AddSavingDialogState();
}

class _AddSavingDialogState extends State<_AddSavingDialog> {
  final _formKey = GlobalKey<FormState>();
  late ImpulseItemResponse? _selected = _initialSelection();
  late final _amount = TextEditingController(
    text: _selected?.defaultAmount.toStringAsFixed(0) ?? '',
  );
  final _note = TextEditingController();
  bool _invested = false;

  ImpulseItemResponse? _initialSelection() {
    final initial = widget.initialImpulse;
    if (initial == null) return widget.impulses.firstOrNull;
    for (final item in widget.impulses) {
      if (item.id == initial.id) return item;
    }
    return widget.impulses.firstOrNull;
  }

  @override
  void dispose() {
    _amount.dispose();
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(context.l10n.recordSaving),
    content: SizedBox(
      width: 440,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  context.l10n.impulseItem,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
              const SizedBox(height: AppDimensions.spaceS),
              Wrap(
                spacing: AppDimensions.spaceS,
                runSpacing: AppDimensions.spaceS,
                children: [
                  for (final item in widget.impulses)
                    ChoiceChip(
                      avatar: Icon(impulseIcon(item.iconKey), size: 18),
                      label: Text(item.name),
                      selected: _selected?.id == item.id,
                      onSelected: (_) => setState(() {
                        _selected = item;
                        _amount.text = item.defaultAmount.toStringAsFixed(0);
                      }),
                    ),
                ],
              ),
              const SizedBox(height: AppDimensions.spaceM),
              GlobalTextFormField(
                controller: _amount,
                labelText: context.l10n.amount,
                prefixText: '₽ ',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                ],
                validator: (value) {
                  final parsed = double.tryParse(
                    (value ?? '').replaceAll(',', '.'),
                  );
                  return parsed == null || parsed <= 0
                      ? context.l10n.numberMustBePositive(context.l10n.amount)
                      : null;
                },
              ),
              const SizedBox(height: AppDimensions.spaceM),
              GlobalTextFormField(
                controller: _note,
                labelText: context.l10n.noteOptional,
                maxLines: 2,
              ),
              CheckboxListTile(
                value: _invested,
                contentPadding: EdgeInsets.zero,
                title: Text(context.l10n.actuallySetAside),
                subtitle: Text(context.l10n.actuallySetAsideDescription),
                onChanged: (value) =>
                    setState(() => _invested = value ?? false),
              ),
            ],
          ),
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(context.l10n.cancel),
      ),
      FilledButton(onPressed: _submit, child: Text(context.l10n.record)),
    ],
  );

  void _submit() {
    if (!_formKey.currentState!.validate() || _selected == null) return;
    context.read<SavingsBloc>().add(
      CreateSavingEvent(
        SavingEventRequest(
          impulseItemId: _selected!.id,
          impulseName: _selected!.name,
          amount: double.parse(_amount.text.replaceAll(',', '.')),
          isInvested: _invested,
          note: _note.text.trim().isEmpty ? null : _note.text.trim(),
        ),
      ),
    );
    Navigator.pop(context);
  }
}

Future<void> showImpulseEditorDialog(
  BuildContext context, {
  ImpulseItemResponse? item,
}) => showDialog<void>(
  context: context,
  builder: (_) => BlocProvider.value(
    value: context.read<SavingsBloc>(),
    child: _ImpulseEditorDialog(item: item),
  ),
);

class _ImpulseEditorDialog extends StatefulWidget {
  const _ImpulseEditorDialog({this.item});
  final ImpulseItemResponse? item;

  @override
  State<_ImpulseEditorDialog> createState() => _ImpulseEditorDialogState();
}

class _ImpulseEditorDialogState extends State<_ImpulseEditorDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.item?.name ?? '');
  late final _amount = TextEditingController(
    text: widget.item?.defaultAmount.toStringAsFixed(0) ?? '',
  );
  late final _frequency = TextEditingController(
    text: (widget.item?.weeklyFrequency ?? 1).toString(),
  );
  late String _iconKey = widget.item?.iconKey ?? 'other';

  @override
  void dispose() {
    _name.dispose();
    _amount.dispose();
    _frequency.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(
      widget.item == null ? context.l10n.addHabit : context.l10n.editHabit,
    ),
    content: SizedBox(
      width: 440,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GlobalTextFormField(
                controller: _name,
                labelText: context.l10n.habitName,
                validator: (value) => (value ?? '').trim().length < 2
                    ? context.l10n.fieldTooShort(context.l10n.habitName, 2)
                    : null,
              ),
              const SizedBox(height: AppDimensions.spaceM),
              GlobalTextFormField(
                controller: _amount,
                labelText: context.l10n.defaultPrice,
                prefixText: '₽ ',
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: AppDimensions.spaceM),
              GlobalTextFormField(
                controller: _frequency,
                labelText: context.l10n.timesPerWeek,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: AppDimensions.spaceM),
              DropdownButtonFormField<String>(
                initialValue: _iconKey,
                decoration: InputDecoration(labelText: context.l10n.chooseIcon),
                items: impulseIconKeys
                    .map(
                      (key) => DropdownMenuItem(
                        value: key,
                        child: Icon(impulseIcon(key)),
                      ),
                    )
                    .toList(),
                onChanged: (value) =>
                    setState(() => _iconKey = value ?? 'other'),
              ),
            ],
          ),
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(context.l10n.cancel),
      ),
      FilledButton(onPressed: _submit, child: Text(context.l10n.save)),
    ],
  );

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final amount = double.tryParse(_amount.text);
    final frequency = int.tryParse(_frequency.text);
    if (amount == null || amount <= 0 || frequency == null) return;
    context.read<SavingsBloc>().add(
      SaveImpulseItem(
        ImpulseItemRequest(
          name: _name.text.trim(),
          defaultAmount: amount,
          iconKey: _iconKey,
          weeklyFrequency: frequency,
          isActive: widget.item?.isActive,
        ),
        id: widget.item?.id,
      ),
    );
    Navigator.pop(context);
  }
}

Future<void> showGoalDialog(BuildContext context) => showDialog<void>(
  context: context,
  builder: (_) => BlocProvider.value(
    value: context.read<SavingsBloc>(),
    child: const _GoalDialog(),
  ),
);

class _GoalDialog extends StatefulWidget {
  const _GoalDialog();

  @override
  State<_GoalDialog> createState() => _GoalDialogState();
}

class _GoalDialogState extends State<_GoalDialog> {
  final _name = TextEditingController();
  final _amount = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(context.l10n.addGoal),
    content: SizedBox(
      width: 420,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GlobalTextFormField(
            controller: _name,
            labelText: context.l10n.goalName,
          ),
          const SizedBox(height: AppDimensions.spaceM),
          GlobalTextFormField(
            controller: _amount,
            labelText: context.l10n.targetAmount,
            prefixText: '₽ ',
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(context.l10n.cancel),
      ),
      FilledButton(
        onPressed: () {
          final amount = double.tryParse(_amount.text);
          if (_name.text.trim().length < 2 || amount == null || amount <= 0)
            return;
          context.read<SavingsBloc>().add(
            CreateSavingsGoal(
              SavingsGoalRequest(name: _name.text.trim(), targetAmount: amount),
            ),
          );
          Navigator.pop(context);
        },
        child: Text(context.l10n.save),
      ),
    ],
  );
}

Future<void> showProjectionSettingsDialog(
  BuildContext context,
  SavingsDashboardResponse dashboard,
) => showDialog<void>(
  context: context,
  builder: (_) => BlocProvider.value(
    value: context.read<SavingsBloc>(),
    child: _ProjectionSettingsDialog(dashboard: dashboard),
  ),
);

class _ProjectionSettingsDialog extends StatefulWidget {
  const _ProjectionSettingsDialog({required this.dashboard});
  final SavingsDashboardResponse dashboard;

  @override
  State<_ProjectionSettingsDialog> createState() =>
      _ProjectionSettingsDialogState();
}

class _ProjectionSettingsDialogState extends State<_ProjectionSettingsDialog> {
  late final _rate = TextEditingController(
    text: widget.dashboard.annualRate.toString(),
  );
  late int _years = widget.dashboard.projectionYears;

  @override
  void dispose() {
    _rate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(context.l10n.rateAndHorizon),
    content: SizedBox(
      width: 420,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GlobalTextFormField(
            controller: _rate,
            labelText: context.l10n.annualRate,
            prefixText: '% ',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: AppDimensions.spaceM),
          DropdownButtonFormField<int>(
            initialValue: _years,
            decoration: InputDecoration(
              labelText: context.l10n.projectionYears,
            ),
            items: const [1, 3, 5, 10, 15, 20, 30]
                .map(
                  (value) =>
                      DropdownMenuItem(value: value, child: Text('$value')),
                )
                .toList(),
            onChanged: (value) => setState(() => _years = value ?? _years),
          ),
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(context.l10n.cancel),
      ),
      FilledButton(
        onPressed: () {
          final rate = double.tryParse(_rate.text.replaceAll(',', '.'));
          if (rate == null || rate < 0 || rate > 100) return;
          context.read<SavingsBloc>().add(
            UpdateSavingsSettings(
              SavingsSettingsRequest(annualRate: rate, projectionYears: _years),
            ),
          );
          Navigator.pop(context);
        },
        child: Text(context.l10n.apply),
      ),
    ],
  );
}
