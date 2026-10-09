import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'package:mobile_template/features/savings/presentation/widgets/financial_display_scope.dart';
import 'package:mobile_template/app/theme/app_dimensions.dart';
import 'package:mobile_template/core/extensions/build_context_extensions.dart';
import 'package:mobile_template/data/models/request/savings_request.dart';
import 'package:mobile_template/data/models/response/savings_response.dart';
import 'package:mobile_template/features/savings/presentation/pages/bloc/savings_bloc.dart';
import 'package:mobile_template/features/savings/presentation/widgets/savings_ui.dart';
import 'package:mobile_template/presentation/widgets/common/editorial_icons.dart';
import 'package:mobile_template/presentation/widgets/common/global_text_form_field.dart';

/// Shared request lifecycle: keep entered data on failure and prevent duplicate
/// writes or dismissing a form before its request finishes.
class _SavingsActionDialog extends StatefulWidget {
  const _SavingsActionDialog({required this.onSubmit, required this.builder});
  final bool Function() onSubmit;
  final Widget Function(BuildContext, bool, VoidCallback) builder;

  @override
  State<_SavingsActionDialog> createState() => _SavingsActionDialogState();
}

class _SavingsActionDialogState extends State<_SavingsActionDialog> {
  bool _submitted = false;

  void _submit() {
    if (_submitted || context.read<SavingsBloc>().state.isSaving) return;
    setState(() => _submitted = true);
    if (!widget.onSubmit()) setState(() => _submitted = false);
  }

  @override
  Widget build(BuildContext context) => BlocConsumer<SavingsBloc, SavingsState>(
    listenWhen: (previous, current) => previous.isSaving && !current.isSaving,
    listener: (context, state) {
      if (!_submitted) return;
      if (state.failure != null) {
        setState(() => _submitted = false);
        return;
      }
      final route = ModalRoute.of(context);
      if (route?.isCurrent == true) {
        Navigator.pop(context);
      } else if (route != null) {
        Navigator.of(context).removeRoute(route);
      }
    },
    builder: (context, state) {
      final busy = _submitted || state.isSaving;
      return PopScope(
        canPop: !busy,
        child: widget.builder(context, busy, _submit),
      );
    },
  );
}

Future<void> showAddSavingDialog(
  BuildContext context,
  List<ImpulseItemResponse> impulses, {
  ImpulseItemResponse? initialImpulse,
}) => showDialog<void>(
  context: context,
  builder: (_) => BlocProvider.value(
    value: context.read<SavingsBloc>(),
    child: _SavingEditorDialog(
      impulses: impulses.where((item) => item.isActive).toList(),
      initialImpulse: initialImpulse,
    ),
  ),
);

Future<void> showEditSavingDialog(
  BuildContext context,
  SavingEventResponse event,
) => showDialog<void>(
  context: context,
  builder: (_) => BlocProvider.value(
    value: context.read<SavingsBloc>(),
    child: _SavingEditorDialog(impulses: const [], event: event),
  ),
);

class _SavingEditorDialog extends StatefulWidget {
  const _SavingEditorDialog({
    required this.impulses,
    this.initialImpulse,
    this.event,
  });
  final List<ImpulseItemResponse> impulses;
  final ImpulseItemResponse? initialImpulse;
  final SavingEventResponse? event;

  @override
  State<_SavingEditorDialog> createState() => _SavingEditorDialogState();
}

class _SavingEditorDialogState extends State<_SavingEditorDialog> {
  late final String _ledgerCurrency = FinancialDisplayScope.of(
    context,
  ).currency;
  final _formKey = GlobalKey<FormState>();
  late ImpulseItemResponse? _selected = _initialSelection();
  late final _amount = TextEditingController(
    text: widget.event != null
        ? moneyInputText(widget.event!.amount)
        : _selected == null
        ? ''
        : moneyInputText(_selected!.defaultAmount),
  );
  late final _note = TextEditingController(text: widget.event?.note ?? '');
  late final _name = TextEditingController(
    text: widget.event?.impulseName ?? '',
  );
  late bool _invested = widget.event?.isInvested ?? false;

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
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _SavingsActionDialog(
    onSubmit: _submit,
    builder: (context, busy, submit) => AlertDialog(
      title: Text(
        widget.event == null
            ? context.l10n.recordSaving
            : context.l10n.editSaving,
      ),
      content: SizedBox(
        width: 440,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.event == null) ...[
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
                          avatar: ImpulseGlyph(
                            keyName: item.iconKey,
                            color: Theme.of(context).colorScheme.primary,
                            size: 18,
                          ),
                          label: Text(item.name),
                          selected: _selected?.id == item.id,
                          onSelected: busy
                              ? null
                              : (_) => setState(() {
                                  _selected = item;
                                  _amount.text = moneyInputText(
                                    item.defaultAmount,
                                  );
                                }),
                        ),
                      ChoiceChip(
                        avatar: const Icon(Icons.edit_outlined, size: 18),
                        label: Text(context.l10n.customSaving),
                        selected: _selected == null,
                        onSelected: busy
                            ? null
                            : (_) => setState(() => _selected = null),
                      ),
                    ],
                  ),
                ],
                if (widget.event != null || _selected == null) ...[
                  if (widget.event == null)
                    const SizedBox(height: AppDimensions.spaceM),
                  GlobalTextFormField(
                    controller: _name,
                    labelText: context.l10n.impulseItem,
                    enabled: !busy,
                    maxLength: 120,
                    textInputAction: TextInputAction.next,
                    validator: (value) => (value ?? '').trim().length < 2
                        ? context.l10n.fieldTooShort(
                            context.l10n.impulseItem,
                            2,
                          )
                        : null,
                  ),
                  if (widget.event == null) ...[
                    const SizedBox(height: AppDimensions.spaceS),
                    Text(
                      context.l10n.customSavingHint,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ],
                const SizedBox(height: AppDimensions.spaceM),
                GlobalTextFormField(
                  controller: _amount,
                  labelText: context.l10n.amount,
                  prefixText:
                      '${widget.event?.currencyCode ?? _selected?.currencyCode ?? _ledgerCurrency} ',
                  enabled: !busy,
                  textInputAction: TextInputAction.next,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                  ],
                  validator: (value) =>
                      validateMoneyInput(context, value, context.l10n.amount),
                ),
                if (widget.event == null) _SavingImpactPreview(amount: _amount),
                const SizedBox(height: AppDimensions.spaceM),
                GlobalTextFormField(
                  controller: _note,
                  labelText: context.l10n.noteOptional,
                  maxLines: 2,
                  maxLength: 500,
                  enabled: !busy,
                ),
                CheckboxListTile(
                  value: _invested,
                  contentPadding: EdgeInsets.zero,
                  title: Text(context.l10n.actuallySetAside),
                  subtitle: Text(context.l10n.actuallySetAsideDescription),
                  onChanged: busy
                      ? null
                      : (value) => setState(() => _invested = value ?? false),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: busy ? null : () => Navigator.pop(context),
          child: Text(context.l10n.cancel),
        ),
        FilledButton(
          onPressed: busy ? null : submit,
          child: busy
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(
                  widget.event == null
                      ? context.l10n.record
                      : context.l10n.save,
                ),
        ),
      ],
    ),
  );

  bool _submit() {
    if (!_formKey.currentState!.validate()) return false;
    final request = SavingEventRequest(
      currencyCode:
          widget.event?.currencyCode ??
          _selected?.currencyCode ??
          _ledgerCurrency,
      impulseItemId: widget.event?.impulseItemId ?? _selected?.id,
      impulseName: widget.event == null && _selected != null
          ? _selected!.name
          : _name.text.trim(),
      amount: double.parse(_amount.text.trim().replaceAll(',', '.')),
      isInvested: _invested,
      note: _note.text.trim().isEmpty ? null : _note.text.trim(),
    );
    context.read<SavingsBloc>().add(
      widget.event == null
          ? CreateSavingEvent(request)
          : UpdateSavingEvent(widget.event!.id, request),
    );
    return true;
  }
}

class _SavingImpactPreview extends StatelessWidget {
  const _SavingImpactPreview({required this.amount});
  final TextEditingController amount;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SavingsBloc>().state;
    final rate = state.dashboard?.annualRate ?? state.settings?.annualRate;
    final years =
        state.dashboard?.projectionYears ?? state.settings?.projectionYears;
    if (rate == null || years == null) return const SizedBox.shrink();
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: amount,
      builder: (context, value, _) {
        if (validateMoneyInput(context, value.text, context.l10n.amount) !=
            null) {
          return const SizedBox.shrink();
        }
        final principal = double.parse(value.text.trim().replaceAll(',', '.'));
        final future = oneSkipFutureValue(principal, rate, years);
        return Padding(
          padding: const EdgeInsets.only(top: AppDimensions.paddingM),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              border: Border(
                left: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 3,
                ),
              ),
            ),
            child: Padding(
              padding: AppDimensions.paddingAllM,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.oneDecisionProjection(
                      years,
                      formatRubles(context, future),
                    ),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppDimensions.spaceS),
                  Text(
                    context.l10n.oneDecisionProjectionHint(
                      formatRate(context, rate),
                    ),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
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
  late final String _ledgerCurrency = FinancialDisplayScope.of(
    context,
  ).currency;
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.item?.name ?? '');
  late final _amount = TextEditingController(
    text: widget.item == null ? '' : moneyInputText(widget.item!.defaultAmount),
  );
  late final _frequency = TextEditingController(
    text: (widget.item?.weeklyFrequency ?? 1).toString(),
  );
  late String _iconKey = widget.item?.iconKey ?? 'other';
  late bool _isActive = widget.item?.isActive ?? true;

  @override
  void dispose() {
    _name.dispose();
    _amount.dispose();
    _frequency.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _SavingsActionDialog(
    onSubmit: _submit,
    builder: (context, busy, submit) => AlertDialog(
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
                  maxLength: 120,
                  enabled: !busy,
                  textInputAction: TextInputAction.next,
                  validator: (value) => (value ?? '').trim().length < 2
                      ? context.l10n.fieldTooShort(context.l10n.habitName, 2)
                      : null,
                ),
                const SizedBox(height: AppDimensions.spaceM),
                GlobalTextFormField(
                  controller: _amount,
                  labelText: context.l10n.defaultPrice,
                  enabled: !busy,
                  textInputAction: TextInputAction.next,
                  prefixText:
                      '${widget.item?.currencyCode ?? _ledgerCurrency} ',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                  ],
                  validator: (value) => validateMoneyInput(
                    context,
                    value,
                    context.l10n.defaultPrice,
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceM),
                GlobalTextFormField(
                  controller: _frequency,
                  labelText: context.l10n.timesPerWeek,
                  enabled: !busy,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => submit(),
                  validator: (value) {
                    final frequency = int.tryParse(value ?? '');
                    return frequency == null || frequency < 0 || frequency > 50
                        ? context.l10n.frequencyRangeError
                        : null;
                  },
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                const SizedBox(height: AppDimensions.spaceS),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    context.l10n.frequencyZeroHint,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceM),
                DropdownButtonFormField<String>(
                  initialValue: _iconKey,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: context.l10n.chooseIcon,
                  ),
                  items: {...impulseIconKeys, _iconKey}
                      .map(
                        (key) => DropdownMenuItem(
                          value: key,
                          child: Row(
                            children: [
                              ImpulseGlyph(
                                keyName: key,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                              const SizedBox(width: AppDimensions.spaceM),
                              Expanded(
                                child: Text(
                                  impulseIconLabel(context, key),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: busy
                      ? null
                      : (value) => setState(() => _iconKey = value ?? 'other'),
                ),
                if (widget.item != null)
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(context.l10n.habitActive),
                    subtitle: Text(context.l10n.habitActiveDescription),
                    value: _isActive,
                    onChanged: busy
                        ? null
                        : (value) => setState(() => _isActive = value),
                  ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: busy ? null : () => Navigator.pop(context),
          child: Text(context.l10n.cancel),
        ),
        FilledButton(
          onPressed: busy ? null : submit,
          child: busy
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(context.l10n.save),
        ),
      ],
    ),
  );

  bool _submit() {
    if (!_formKey.currentState!.validate()) return false;
    final amount = double.tryParse(_amount.text.trim().replaceAll(',', '.'));
    final frequency = int.tryParse(_frequency.text);
    if (amount == null || amount <= 0 || frequency == null) return false;
    context.read<SavingsBloc>().add(
      SaveImpulseItem(
        ImpulseItemRequest(
          currencyCode: widget.item?.currencyCode ?? _ledgerCurrency,
          name: _name.text.trim(),
          defaultAmount: amount,
          iconKey: _iconKey,
          weeklyFrequency: frequency,
          isActive: widget.item == null ? null : _isActive,
        ),
        id: widget.item?.id,
      ),
    );
    return true;
  }
}

Future<void> showGoalDialog(
  BuildContext context, {
  SavingsGoalResponse? goal,
}) => showDialog<void>(
  context: context,
  builder: (_) => BlocProvider.value(
    value: context.read<SavingsBloc>(),
    child: _GoalDialog(goal: goal),
  ),
);

class _GoalDialog extends StatefulWidget {
  const _GoalDialog({this.goal});
  final SavingsGoalResponse? goal;

  @override
  State<_GoalDialog> createState() => _GoalDialogState();
}

class _GoalDialogState extends State<_GoalDialog> {
  late final String _ledgerCurrency = FinancialDisplayScope.of(
    context,
  ).currency;
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.goal?.name ?? '');
  late final _amount = TextEditingController(
    text: widget.goal == null ? '' : moneyInputText(widget.goal!.targetAmount),
  );

  @override
  void dispose() {
    _name.dispose();
    _amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _SavingsActionDialog(
    onSubmit: _submit,
    builder: (context, busy, submit) => AlertDialog(
      title: Text(
        widget.goal == null ? context.l10n.addGoal : context.l10n.editGoal,
      ),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GlobalTextFormField(
                  controller: _name,
                  labelText: context.l10n.goalName,
                  maxLength: 120,
                  enabled: !busy,
                  textInputAction: TextInputAction.next,
                  validator: (value) => (value ?? '').trim().length < 2
                      ? context.l10n.fieldTooShort(context.l10n.goalName, 2)
                      : null,
                ),
                const SizedBox(height: AppDimensions.spaceM),
                GlobalTextFormField(
                  controller: _amount,
                  labelText: context.l10n.targetAmount,
                  prefixText:
                      '${widget.goal?.currencyCode ?? _ledgerCurrency} ',
                  enabled: !busy,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => submit(),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                  ],
                  validator: (value) =>
                      validateMoneyInput(
                        context,
                        value,
                        context.l10n.targetAmount,
                      ) ??
                      ((double.tryParse((value ?? '').replaceAll(',', '.')) ??
                                  0) <
                              (widget.goal?.allocatedAmount ?? 0)
                          ? context.l10n.goalBelowAllocation
                          : null),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: busy ? null : () => Navigator.pop(context),
          child: Text(context.l10n.cancel),
        ),
        FilledButton(
          onPressed: busy ? null : submit,
          child: busy
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(context.l10n.save),
        ),
      ],
    ),
  );

  bool _submit() {
    if (!_formKey.currentState!.validate()) return false;
    final request = SavingsGoalRequest(
      currencyCode: widget.goal?.currencyCode ?? _ledgerCurrency,
      name: _name.text.trim(),
      targetAmount: double.parse(_amount.text.trim().replaceAll(',', '.')),
    );
    context.read<SavingsBloc>().add(
      widget.goal == null
          ? CreateSavingsGoal(request)
          : UpdateSavingsGoal(widget.goal!.id, request),
    );
    return true;
  }
}

Future<void> showGoalAllocationDialog(
  BuildContext context,
  SavingsGoalResponse goal,
  SavingsDashboardResponse dashboard,
) => showDialog<void>(
  context: context,
  builder: (_) => BlocProvider.value(
    value: context.read<SavingsBloc>(),
    child: _GoalAllocationDialog(goal: goal, dashboard: dashboard),
  ),
);

class _GoalAllocationDialog extends StatefulWidget {
  const _GoalAllocationDialog({required this.goal, required this.dashboard});
  final SavingsGoalResponse goal;
  final SavingsDashboardResponse dashboard;
  @override
  State<_GoalAllocationDialog> createState() => _GoalAllocationDialogState();
}

class _GoalAllocationDialogState extends State<_GoalAllocationDialog> {
  final _form = GlobalKey<FormState>();
  late final _amount = TextEditingController(
    text: moneyInputText(widget.goal.allocatedAmount),
  );
  double get _capacity => math.max(
    0,
    math.min(
      widget.goal.targetAmount,
      widget.dashboard.investedTotal -
          widget.dashboard.goals.fold<double>(
            0,
            (sum, goal) => sum + goal.allocatedAmount,
          ) +
          widget.goal.allocatedAmount,
    ),
  );
  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _SavingsActionDialog(
    onSubmit: () {
      if (!_form.currentState!.validate()) return false;
      context.read<SavingsBloc>().add(
        AllocateSavingsGoal(
          widget.goal.id,
          GoalAllocationRequest(
            allocatedAmount: double.parse(
              _amount.text.trim().replaceAll(',', '.'),
            ),
          ),
        ),
      );
      return true;
    },
    builder: (context, busy, submit) => AlertDialog(
      title: Text(context.l10n.allocateGoal),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Form(
            key: _form,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  widget.goal.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppDimensions.spaceM),
                Text(
                  context.l10n.allocationCapacity(
                    formatRubles(
                      context,
                      _capacity,
                      currencyCode: widget.goal.currencyCode,
                      original: true,
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceM),
                GlobalTextFormField(
                  controller: _amount,
                  enabled: !busy,
                  labelText: context.l10n.allocatedAmount,
                  prefixText: '${widget.goal.currencyCode} ',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => submit(),
                  validator: (value) {
                    final text = (value ?? '').trim();
                    final amount = double.tryParse(text.replaceAll(',', '.'));
                    if (amount == null ||
                        !amount.isFinite ||
                        amount < 0 ||
                        !RegExp(r'^\d{1,10}([.,]\d{1,2})?$').hasMatch(text)) {
                      return context.l10n.allocationInvalid;
                    }
                    return (amount * 100).round() > (_capacity * 100).round()
                        ? context.l10n.allocationTooLarge
                        : null;
                  },
                ),
                TextButton(
                  onPressed: busy ? null : () => _amount.text = '0',
                  child: Text(context.l10n.releaseGoalMoney),
                ),
                Text(
                  context.l10n.allocationHint,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: busy ? null : () => Navigator.pop(context),
          child: Text(context.l10n.cancel),
        ),
        FilledButton(
          onPressed: busy ? null : submit,
          child: Text(busy ? context.l10n.loading : context.l10n.save),
        ),
      ],
    ),
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
  final _formKey = GlobalKey<FormState>();
  late final _rate = TextEditingController(
    text: moneyInputText(widget.dashboard.annualRate),
  );
  late int _years = projectionPeriods.contains(widget.dashboard.projectionYears)
      ? widget.dashboard.projectionYears
      : projectionPeriods.last;
  late String _currency = widget.dashboard.currencyCode;
  late String _displayCurrency = widget.dashboard.displayCurrency;
  late String _region = widget.dashboard.financialRegion;
  static const _regions = {
    'RU': 'Россия',
    'US': 'United States',
    'ES': 'España',
    'FR': 'France',
    'DE': 'Deutschland',
    'BR': 'Brasil',
    'CN': '中国',
    'IN': 'भारत',
    'SA': 'السعودية',
    'KZ': 'Қазақстан',
  };

  FinancialPresetResponse? get _preset => widget.dashboard.regionalPresets
      .where((item) => item.region == _region)
      .firstOrNull;

  @override
  void dispose() {
    _rate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _SavingsActionDialog(
    onSubmit: _submit,
    builder: (context, busy, submit) => AlertDialog(
      title: Text(context.l10n.financialSettings),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: _region,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: context.l10n.financialRegion,
                  ),
                  items: [
                    for (final entry in _regions.entries)
                      DropdownMenuItem(
                        value: entry.key,
                        child: Text(entry.value),
                      ),
                  ],
                  onChanged: busy
                      ? null
                      : (value) => setState(() => _region = value ?? _region),
                ),
                OutlinedButton.icon(
                  onPressed: busy || _preset == null
                      ? null
                      : () => setState(() {
                          _currency = _preset!.currencyCode;
                          _displayCurrency = _currency;
                          _rate.text = moneyInputText(_preset!.annualRate);
                        }),
                  icon: const Icon(Icons.public_outlined),
                  label: Text(context.l10n.applyRegionDefaults),
                ),
                Text(
                  context.l10n.regionalDefaultsHint,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: AppDimensions.spaceM),
                DropdownButtonFormField<String>(
                  key: ValueKey('record-$_currency'),
                  initialValue: _currency,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: context.l10n.recordCurrency,
                  ),
                  items: [
                    for (final code in financialCurrencies)
                      DropdownMenuItem(
                        value: code,
                        child: Text('$code · ${currencySymbol(code)}'),
                      ),
                  ],
                  onChanged: busy
                      ? null
                      : (value) => setState(() {
                          if (value != null && value != _currency) {
                            _currency = value;
                            _rate.text = '0';
                          }
                        }),
                ),
                const SizedBox(height: AppDimensions.spaceM),
                Text(
                  context.l10n.currencyLedgerHint,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: AppDimensions.spaceM),
                DropdownButtonFormField<String>(
                  key: ValueKey('display-$_displayCurrency'),
                  initialValue: _displayCurrency,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: context.l10n.displayCurrency,
                  ),
                  items: [
                    for (final code in financialCurrencies)
                      DropdownMenuItem(
                        value: code,
                        child: Text('$code · ${currencySymbol(code)}'),
                      ),
                  ],
                  onChanged: busy
                      ? null
                      : (value) => setState(
                          () => _displayCurrency = value ?? _displayCurrency,
                        ),
                ),
                const SizedBox(height: AppDimensions.spaceM),
                Text(
                  context.l10n.conversionHint,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: AppDimensions.spaceM),
                GlobalTextFormField(
                  controller: _rate,
                  labelText: context.l10n.annualRate,
                  prefixText: '% ',
                  enabled: !busy,
                  textInputAction: TextInputAction.next,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                  ],
                  validator: (value) {
                    final text = (value ?? '').trim();
                    final rate = double.tryParse(text.replaceAll(',', '.'));
                    return rate == null ||
                            !rate.isFinite ||
                            rate < 0 ||
                            rate > 100 ||
                            !RegExp(r'^\d{1,3}([.,]\d{1,2})?$').hasMatch(text)
                        ? context.l10n.rateFormatError
                        : null;
                  },
                ),
                const SizedBox(height: AppDimensions.spaceS),
                Text(
                  context.l10n.rateReferenceHint,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (_preset?.currencyCode == _currency &&
                    _preset?.rateReference.isNotEmpty == true) ...[
                  Text(
                    _preset!.rateReference,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  SelectableText(
                    _preset!.rateSource,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ] else
                  Text(
                    context.l10n.rateNeedsInput,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                const SizedBox(height: AppDimensions.spaceM),
                DropdownButtonFormField<int>(
                  initialValue: _years,
                  decoration: InputDecoration(
                    labelText: context.l10n.projectionYears,
                  ),
                  items: projectionPeriods
                      .map(
                        (value) => DropdownMenuItem(
                          value: value,
                          child: Text(context.l10n.projectionPeriod(value)),
                        ),
                      )
                      .toList(),
                  onChanged: busy
                      ? null
                      : (value) => setState(() => _years = value ?? _years),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: busy ? null : () => Navigator.pop(context),
          child: Text(context.l10n.cancel),
        ),
        FilledButton(
          onPressed: busy ? null : submit,
          child: busy
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(context.l10n.apply),
        ),
      ],
    ),
  );

  bool _submit() {
    if (!_formKey.currentState!.validate()) return false;
    context.read<SavingsBloc>().add(
      UpdateSavingsSettings(
        SavingsSettingsRequest(
          annualRate: double.parse(_rate.text.trim().replaceAll(',', '.')),
          projectionYears: _years,
          currencyCode: _currency,
          displayCurrency: _displayCurrency,
          financialRegion: _region,
        ),
      ),
    );
    return true;
  }
}
