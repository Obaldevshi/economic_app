import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_template/app/theme/app_theme.dart';
import 'package:mobile_template/features/auth/presentation/widgets/auth_scroll_scaffold.dart';

void main() {
  for (final size in [
    const Size(320, 568),
    const Size(360, 640),
    const Size(550, 700),
    const Size(551, 700),
    const Size(1280, 720),
  ]) {
    testWidgets('auth form scrolls without overflow at $size', (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = size;
      tester.view.padding = const FakeViewPadding(bottom: 24);
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: AuthScrollScaffold(
            hero: const SizedBox(
              height: 420,
              child: Center(child: Text('Recovery')),
            ),
            form: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const TextField(key: ValueKey('email')),
                const SizedBox(height: 24),
                const TextField(),
                const SizedBox(height: 24),
                const TextField(),
                const SizedBox(height: 24),
                FilledButton(
                  key: const ValueKey('submit'),
                  onPressed: () {},
                  child: const Text('Continue'),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.ensureVisible(find.byKey(const ValueKey('submit')));
      await tester.pumpAndSettle();
      final button = tester.getRect(find.byKey(const ValueKey('submit')));
      expect(button.bottom, lessThanOrEqualTo(size.height - 24));
      expect(button.top, greaterThanOrEqualTo(0));
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets(
    'resize keeps entered data and keyboard leaves focused field visible',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(1280, 720);
      addTearDown(tester.view.reset);
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        MaterialApp(
          home: AuthScrollScaffold(
            hero: const SizedBox(height: 300),
            form: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 160),
                TextField(key: const ValueKey('email'), controller: controller),
                const SizedBox(height: 100),
                FilledButton(onPressed: () {}, child: const Text('Continue')),
              ],
            ),
          ),
        ),
      );
      await tester.enterText(
        find.byKey(const ValueKey('email')),
        'test@example.test',
      );
      tester.view.physicalSize = const Size(360, 640);
      await tester.pumpAndSettle();
      expect(controller.text, 'test@example.test');
      await tester.ensureVisible(find.byKey(const ValueKey('email')));
      await tester.tap(find.byKey(const ValueKey('email')));
      tester.view.viewInsets = const FakeViewPadding(bottom: 280);
      await tester.pumpAndSettle();
      expect(
        tester.getRect(find.byKey(const ValueKey('email'))).bottom,
        lessThanOrEqualTo(360),
      );
      expect(controller.text, 'test@example.test');
      expect(tester.takeException(), isNull);
    },
  );
}
