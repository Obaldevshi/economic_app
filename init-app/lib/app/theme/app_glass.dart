import 'package:flutter/material.dart';

/// Лёгкие токены поверхностей без blur, прозрачных слоёв и тяжёлых теней.
///
/// Имя сохранено для совместимости с существующими виджетами шаблона.
abstract final class AppGlass {
  static const double borderWidth = 1;

  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color fill(BuildContext context) =>
      Theme.of(context).colorScheme.surface;

  static Color border(BuildContext context) =>
      Theme.of(context).colorScheme.outlineVariant;

  static Color inputBorder(BuildContext context) =>
      Theme.of(context).colorScheme.outline;

  static Color inputBorderOnGradient(BuildContext context) =>
      Colors.white.withValues(alpha: 0.7);
}
