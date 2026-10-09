import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mobile_template/features/savings/presentation/widgets/financial_display_scope.dart';
import 'package:mobile_template/app/theme/app_dimensions.dart';
import 'package:mobile_template/core/extensions/build_context_extensions.dart';
import 'package:mobile_template/core/utils/receipt_export.dart';
import 'package:mobile_template/data/models/response/savings_response.dart';
import 'package:mobile_template/features/savings/presentation/pages/bloc/savings_bloc.dart';
import 'package:mobile_template/features/savings/presentation/widgets/savings_ui.dart';
import 'package:mobile_template/presentation/widgets/common/brand_mark.dart';

Future<void> showSavingReceipt(
  BuildContext context,
  SavingEventResponse event,
) => showDialog<void>(
  context: context,
  builder: (_) => FinancialDisplayScope(
    data: FinancialDisplayScope.of(context),
    child: _ReceiptDialog(event: event),
  ),
);

Future<void> showWeeklyReceiptDialog(BuildContext context) {
  final bloc = context.read<SavingsBloc>()..add(const LoadWeeklyReceipt());
  return showDialog<void>(
    context: context,
    builder: (_) => BlocProvider.value(
      value: bloc,
      child: BlocBuilder<SavingsBloc, SavingsState>(
        builder: (context, state) {
          if (state.isReceiptLoading)
            return const AlertDialog(
              content: SizedBox(
                height: 100,
                child: Center(child: CircularProgressIndicator()),
              ),
            );
          final receipt = state.weeklyReceipt;
          if (receipt == null)
            return AlertDialog(
              content: SavingsLoadError(
                onRetry: () => bloc.add(const LoadWeeklyReceipt()),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(context.l10n.cancel),
                ),
              ],
            );
          return FinancialDisplayScope(
            data: FinancialDisplayScope.of(context),
            child: _ReceiptDialog(week: receipt),
          );
        },
      ),
    ),
  );
}

class _ReceiptDialog extends StatefulWidget {
  const _ReceiptDialog({this.event, this.week});
  final SavingEventResponse? event;
  final WeeklyReceiptResponse? week;
  @override
  State<_ReceiptDialog> createState() => _ReceiptDialogState();
}

class _ReceiptDialogState extends State<_ReceiptDialog> {
  final _capture = GlobalKey();
  bool _private = true;
  bool _exporting = false;

  Future<void> _export() async {
    if (_exporting) return;
    setState(() => _exporting = true);
    try {
      // Ensure a long receipt has been painted even after scrolling to its footer.
      await Scrollable.ensureVisible(_capture.currentContext!);
      await WidgetsBinding.instance.endOfFrame;
      if (!mounted) return;
      final boundary =
          _capture.currentContext!.findRenderObject()! as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 2);
      try {
        final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
        if (bytes == null) throw StateError('Receipt rendering failed');
        await exportReceipt(
          bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes),
        );
      } finally {
        image.dispose();
      }
    } catch (_) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.receiptExportFailed)),
        );
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final event = widget.event;
    final week = widget.week;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final date = week == null
        ? DateFormat.yMMMd(locale).format(event!.occurredAt.toLocal())
        : '${DateFormat.MMMd(locale).format(week.startDate)} — ${DateFormat.yMMMd(locale).format(week.endDate)}';
    return AlertDialog(
      title: Text(context.l10n.savingReceipt),
      content: SizedBox(
        width: 380,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RepaintBoundary(
                key: _capture,
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    color: Color(0xFFF4F0E5),
                    border: Border(
                      top: BorderSide(color: Color(0xFF272D34), width: 5),
                      bottom: BorderSide(color: Color(0xFF272D34), width: 5),
                    ),
                  ),
                  child: Theme(
                    data: ThemeData.light().copyWith(
                      textTheme: ThemeData.light().textTheme.apply(
                        bodyColor: const Color(0xFF272D34),
                        displayColor: const Color(0xFF272D34),
                      ),
                    ),
                    child: Padding(
                      padding: AppDimensions.paddingAllL,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Center(child: BrandMark(size: 36)),
                          const SizedBox(height: AppDimensions.spaceM),
                          Text(
                            context.l10n.appName,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: 'serif',
                              fontSize: 25,
                              color: Color(0xFF272D34),
                            ),
                          ),
                          const SizedBox(height: AppDimensions.spaceS),
                          Text(
                            week == null
                                ? context.l10n.receiptPurchaseNotMade
                                : context.l10n.weeklyReceipt,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Color(0xFF272D34)),
                          ),
                          const Divider(height: 32, color: Color(0xFFAAAD9C)),
                          Text(
                            date,
                            style: const TextStyle(color: Color(0xFF272D34)),
                          ),
                          if (event != null) ...[
                            const SizedBox(height: AppDimensions.spaceM),
                            Text(
                              _private
                                  ? context.l10n.receiptPrivateDecision
                                  : event.impulseName,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Color(0xFF272D34),
                              ),
                            ),
                          ],
                          const SizedBox(height: AppDimensions.spaceM),
                          Text(
                            context.l10n.savedTotal,
                            style: const TextStyle(color: Color(0xFF272D34)),
                          ),
                          Text(
                            formatRubles(
                              context,
                              week?.totalSaved ?? event!.amount,
                              currencyCode:
                                  week?.currencyCode ?? event!.currencyCode,
                            ),
                            style: const TextStyle(
                              fontFamily: 'serif',
                              fontSize: 32,
                              color: Color(0xFF272D34),
                            ),
                          ),
                          const SizedBox(height: AppDimensions.spaceM),
                          Text(
                            '${context.l10n.realSavings}: ${formatRubles(context, week?.investedTotal ?? (event!.isInvested ? event.amount : 0), currencyCode: week?.currencyCode ?? event!.currencyCode)}',
                            style: const TextStyle(color: Color(0xFF272D34)),
                          ),
                          if (week != null)
                            Text(
                              '${context.l10n.decisionCount}: ${week.decisionCount}',
                              style: const TextStyle(color: Color(0xFF272D34)),
                            ),
                          const Divider(height: 32, color: Color(0xFFAAAD9C)),
                          if (FinancialDisplayScope.of(context).rates?.asOf !=
                              null)
                            Text(
                              context.l10n.exchangeRateDate(
                                DateFormat.yMd(
                                  Localizations.localeOf(
                                    context,
                                  ).toLanguageTag(),
                                ).format(
                                  FinancialDisplayScope.of(
                                    context,
                                  ).rates!.asOf!,
                                ),
                              ),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF666A70),
                              ),
                            ),
                          Text(
                            context.l10n.receiptFooter,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF666A70),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (event != null)
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _private,
                  title: Text(context.l10n.receiptHideName),
                  onChanged: _exporting
                      ? null
                      : (value) => setState(() => _private = value),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _exporting ? null : () => Navigator.pop(context),
          child: Text(context.l10n.cancel),
        ),
        FilledButton.icon(
          onPressed: _exporting ? null : _export,
          icon: const Icon(Icons.ios_share_outlined),
          label: Text(
            _exporting ? context.l10n.loading : context.l10n.receiptExport,
          ),
        ),
      ],
    );
  }
}
