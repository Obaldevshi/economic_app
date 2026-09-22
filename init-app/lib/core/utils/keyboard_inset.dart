import 'package:flutter/material.dart';

/// Общие помощники для клавиатуры, фокуса и IME-отступов.
abstract final class KeyboardInset {
  KeyboardInset._();

  static const Duration _dismissSettle = Duration(milliseconds: 300);

  static double of(BuildContext context) =>
      MediaQuery.viewInsetsOf(context).bottom;

  /// Высота клавиатуры напрямую из FlutterView.
  ///
  /// Это важно для Scaffold с `resizeToAvoidBottomInset: false`: у его
  /// дочернего MediaQuery унаследованный viewInsets может быть уже обнулён.
  static double fromView(BuildContext context) {
    final view = View.maybeOf(context);
    if (view == null) return of(context);
    return MediaQueryData.fromView(view).viewInsets.bottom;
  }

  static double resolve(BuildContext context) {
    final inherited = of(context);
    final fromView = KeyboardInset.fromView(context);
    return inherited > fromView ? inherited : fromView;
  }

  static void dismiss() => FocusManager.instance.primaryFocus?.unfocus();

  static Future<void> dismissAndWait({Duration delay = _dismissSettle}) async {
    final hadFocus = FocusManager.instance.primaryFocus?.hasFocus ?? false;
    dismiss();
    if (hadFocus) await Future<void>.delayed(delay);
  }

  /// Поднимает активное поле в видимую область после появления клавиатуры.
  static void ensureFocusedVisible(
    BuildContext context, {
    Duration duration = const Duration(milliseconds: 280),
  }) {
    void scroll() {
      if (!context.mounted) return;
      final focusContext = FocusManager.instance.primaryFocus?.context;
      if (focusContext == null || !focusContext.mounted) return;
      Scrollable.ensureVisible(
        focusContext,
        duration: duration,
        curve: Curves.easeOutCubic,
        alignment: 0.15,
        alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => scroll());
    Future<void>.delayed(const Duration(milliseconds: 320), scroll);
  }
}

/// Перестраивает только IME-зависимую часть дерева при изменении метрик окна.
class KeyboardInsetBuilder extends StatefulWidget {
  const KeyboardInsetBuilder({
    required this.builder,
    this.onOpened,
    this.onClosed,
    super.key,
  });

  final Widget Function(BuildContext context, double inset) builder;
  final VoidCallback? onOpened;
  final VoidCallback? onClosed;

  @override
  State<KeyboardInsetBuilder> createState() => _KeyboardInsetBuilderState();
}

class _KeyboardInsetBuilderState extends State<KeyboardInsetBuilder>
    with WidgetsBindingObserver {
  bool _wasOpen = false;
  double _lastInset = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    if (!mounted) return;
    final next = KeyboardInset.resolve(context);
    if (next != _lastInset) setState(() {});
  }

  void _notifyTransitions(double inset) {
    final isOpen = inset > 0;
    if (isOpen && !_wasOpen) {
      widget.onOpened?.call();
    } else if (!isOpen && _wasOpen) {
      widget.onClosed?.call();
    }
    _wasOpen = isOpen;
    _lastInset = inset;
  }

  @override
  Widget build(BuildContext context) {
    final inset = KeyboardInset.resolve(context);
    if (inset != _lastInset || (inset > 0) != _wasOpen) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _notifyTransitions(KeyboardInset.resolve(context));
      });
    }
    return widget.builder(context, inset);
  }
}
