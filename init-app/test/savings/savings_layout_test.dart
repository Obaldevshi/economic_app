import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_template/app/theme/app_theme.dart';
import 'package:mobile_template/core/di/di.dart';
import 'package:mobile_template/core/services/savings_native_service.dart';
import 'package:mobile_template/core/services/session_service.dart';
import 'package:mobile_template/core/services/locale_service.dart';
import 'package:mobile_template/data/models/response/savings_response.dart';
import 'package:mobile_template/data/repositories/savings_repository.dart';
import 'package:mobile_template/features/savings/presentation/pages/bloc/savings_bloc.dart';
import 'package:mobile_template/features/savings/presentation/pages/impulse_items_page.dart';
import 'package:mobile_template/features/savings/presentation/pages/savings_dashboard_page.dart';
import 'package:mobile_template/features/savings/presentation/pages/saving_history_page.dart';
import 'package:mobile_template/features/savings/presentation/pages/spent_page.dart';
import 'package:mobile_template/features/savings/presentation/widgets/savings_dialogs.dart';
import 'package:mobile_template/generated/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../support/memory_secure_storage.dart';

/// UI-only fixture. Any accidental repository call fails instead of networking.
class _UnusedRepository implements SavingsRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw StateError('Unexpected repository call in layout test');
}

class _LayoutBloc extends SavingsBloc {
  _LayoutBloc(super.repository, super.native);
  void seed(SavingsState value) => emit(value);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late _LayoutBloc bloc;
  late SessionService session;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    getIt.registerSingleton<LocaleService>(LocaleService(prefs));
    session = await SessionService.create(MemorySecureStorage(), prefs);
    final native = SavingsNativeService(prefs, session);
    getIt.registerSingleton<SavingsNativeService>(native);
    bloc = _LayoutBloc(_UnusedRepository(), native);
    final events = [
      SavingEventResponse(
        id: 1,
        impulseName: 'Кофе с десертом и дополнительные покупки по дороге домой',
        amount: 12345.67,
        occurredAt: DateTime(2026, 10, 18),
        isInvested: true,
        note:
            'Длинная заметка о том, как удалось избежать импульсивной покупки.',
      ),
    ];
    bloc.seed(
      SavingsState(
        dashboard: SavingsDashboardResponse(
          todayTotal: 12345.67,
          monthTotal: 65432.10,
          totalSaved: 1234567.89,
          investedTotal: 123456.78,
          monthlyPace: 12345.67,
          annualRate: 12,
          projectionYears: 5,
          projectedTotal: 2345678.90,
          projectedInterest: 100000,
          monthlySeries: [
            MonthlySavingPoint(month: '2026-10', amount: 12345.67),
          ],
          projectionSeries: [
            ProjectionPoint(
              year: 1,
              contributions: 12345.67,
              interest: 1000,
              total: 13345.67,
            ),
          ],
          impulseTotals: [
            ImpulseTotal(name: events.first.impulseName, amount: 12345.67),
          ],
          recentEvents: events,
          goals: [
            SavingsGoalResponse(
              id: 1,
              name: 'Длительное путешествие всей семьёй и новые впечатления',
              targetAmount: 2345678.90,
              allocatedAmount: 12345.67,
            ),
          ],
        ),
        history: events,
        historyPage: 1,
        historyTotal: 1,
        spent: [
          SpentEventResponse(
            id: 1,
            currencyCode: 'RUB',
            impulseName: events.first.impulseName,
            amount: 12345.67,
            occurredAt: events.first.occurredAt,
            note: events.first.note,
          ),
        ],
        spentPage: 1,
        spentTotal: 1,
        spentAmount: 12345.67,
        spentCurrency: 'RUB',
        settings: SavingsSettingsResponse(annualRate: 12, projectionYears: 5),
        impulses: List.generate(
          4,
          (index) => ImpulseItemResponse(
            id: index + 1,
            name: 'Кофе с десертом и дополнительные покупки по дороге домой',
            defaultAmount: 12345.67,
            iconKey: 'coffee',
            weeklyFrequency: 7,
            isActive: true,
          ),
        ),
      ),
    );
  });

  tearDown(() async {
    await bloc.close();
    session.dispose();
    await getIt.reset();
  });

  final dialogs = <String, Future<void> Function(BuildContext, SavingsState)>{
    'saving': (context, state) => showAddSavingDialog(context, state.impulses),
    'spent': (context, state) =>
        showSpentDialog(context, state.impulses, currencyCode: 'RUB'),
    'habit': (context, state) => showImpulseEditorDialog(context),
    'goal': (context, state) => showGoalDialog(context),
    'allocation': (context, state) => showGoalAllocationDialog(
      context,
      state.dashboard!.goals.first,
      state.dashboard!,
    ),
    'settings': (context, state) =>
        showProjectionSettingsDialog(context, state.dashboard!),
  };
  for (final dialog in dialogs.entries) {
    for (final size in [const Size(320, 568), const Size(360, 640)]) {
      testWidgets(
        '${dialog.key} editor keeps focused field above keyboard at $size',
        (tester) async {
          tester.view.devicePixelRatio = 1;
          tester.view.physicalSize = size;
          addTearDown(tester.view.reset);
          late BuildContext host;
          await tester.pumpWidget(
            BlocProvider<SavingsBloc>.value(
              value: bloc,
              child: MaterialApp(
                locale: const Locale('ru'),
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                theme: AppTheme.lightTheme,
                home: Builder(
                  builder: (context) {
                    host = context;
                    return const Scaffold();
                  },
                ),
              ),
            ),
          );
          final result = dialog.value(host, bloc.state);
          await tester.pumpAndSettle();
          final field = find.byType(TextField).last;
          await tester.ensureVisible(field);
          await tester.enterText(field, '42');
          tester.view.viewInsets = const FakeViewPadding(bottom: 280);
          await tester.pumpAndSettle();
          expect(
            tester.getRect(field).bottom,
            lessThanOrEqualTo(size.height - 280),
          );
          final action = find
              .descendant(
                of: find.byType(AlertDialog),
                matching: find.byType(FilledButton),
              )
              .last;
          expect(
            tester.getRect(action).bottom,
            lessThanOrEqualTo(size.height - 280),
          );
          expect(tester.takeException(), isNull);
          tester.view.physicalSize = const Size(1000, 720);
          tester.view.viewInsets = const FakeViewPadding();
          await tester.pumpAndSettle();
          expect(tester.widget<TextField>(field).controller!.text, '42');
          expect(tester.takeException(), isNull);
          Navigator.of(tester.element(find.byType(AlertDialog))).pop();
          await tester.pumpAndSettle();
          await result;
        },
      );
    }
  }

  final pages = <String, Widget>{
    'home': const SavingsDashboardPage(),
    'history': const SavingHistoryPage(),
    'spent': const SpentPage(),
    'forecast': const SavingsForecastPage(),
  };
  for (final page in pages.entries) {
    for (final width in [320.0, 551.0, 1280.0]) {
      for (final scale in [1.0, 1.4]) {
        testWidgets('${page.key} has no overflow at $width / $scale', (
          tester,
        ) async {
          tester.view.devicePixelRatio = 1;
          tester.view.physicalSize = Size(width, 720);
          addTearDown(tester.view.reset);
          await tester.pumpWidget(
            BlocProvider<SavingsBloc>.value(
              value: bloc,
              child: MaterialApp(
                locale: const Locale('ru'),
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                theme: AppTheme.lightTheme,
                builder: (context, child) => MediaQuery(
                  data: MediaQuery.of(
                    context,
                  ).copyWith(textScaler: TextScaler.linear(scale)),
                  child: child!,
                ),
                home: Scaffold(body: page.value),
              ),
            ),
          );
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          for (var step = 0; step < 4; step++) {
            await tester.drag(
              find.byType(CustomScrollView),
              const Offset(0, -600),
            );
            await tester.pumpAndSettle();
            expect(tester.takeException(), isNull);
          }
        });
      }
    }
  }

  for (final width in [320.0, 551.0, 1280.0]) {
    for (final scale in [1.0, 1.4]) {
      testWidgets('habits remain usable at width $width, text scale $scale', (
        tester,
      ) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = Size(width, 720);
        addTearDown(tester.view.reset);
        await tester.pumpWidget(
          BlocProvider<SavingsBloc>.value(
            value: bloc,
            child: MaterialApp(
              locale: const Locale('ru'),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              theme: AppTheme.lightTheme,
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: TextScaler.linear(scale)),
                child: child!,
              ),
              home: const Scaffold(body: ImpulseItemsPage()),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await tester.drag(find.byType(CustomScrollView), const Offset(0, -900));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }
  }
}
