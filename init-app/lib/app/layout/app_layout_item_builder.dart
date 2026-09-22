import 'package:flutter/widgets.dart';

/// Выбирает значение или виджет для узкой и широкой компоновки.
///
/// По умолчанию экран считается узким при ширине до 550 логических пикселей.
class AppLayoutItemBuilder<T extends Object?> {
  const AppLayoutItemBuilder({required this.wide, required this.narrow});

  factory AppLayoutItemBuilder.values({required T wide, required T narrow}) =>
      AppLayoutItemBuilder(wide: () => wide, narrow: () => narrow);

  /// Значение для широких экранов.
  final ValueGetter<T> wide;

  /// Значение для узких экранов.
  final ValueGetter<T> narrow;

  T call(BuildContext context, {double? width}) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    return screenWidth <= (width ?? 550) ? narrow() : wide();
  }
}
