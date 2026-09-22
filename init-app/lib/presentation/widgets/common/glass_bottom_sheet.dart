import 'package:mobile_template/app/layout/app_layout_item_builder.dart';
import 'package:mobile_template/app/theme/app_dimensions.dart';
import 'package:mobile_template/core/utils/keyboard_inset.dart';
import 'package:mobile_template/presentation/widgets/common/glass_surface.dart';
import 'package:flutter/material.dart';

/// Лёгкий modal bottom sheet со сплошной поверхностью.
class GlassBottomSheet extends StatelessWidget {
  const GlassBottomSheet({required this.child, this.title, super.key});

  final Widget child;
  final String? title;

  static Future<T?> show<T>(
    BuildContext context, {
    required Widget child,
    String? title,
  }) async {
    await KeyboardInset.dismissAndWait();
    if (!context.mounted) return null;
    return showModalBottomSheet<T>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.32),
      builder: (context) => GlassBottomSheet(title: title, child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardInsetBuilder(
      builder: (context, bottomInset) {
        final maxHeight =
            MediaQuery.sizeOf(context).height * 0.92 - bottomInset;

        final borderRadius = AppLayoutItemBuilder<BorderRadius>.values(
          narrow: const BorderRadius.vertical(
            top: Radius.circular(AppDimensions.radius),
          ),
          wide: AppDimensions.borderRadius,
        )(context);

        final sheet = GlassSurface(
          variant: GlassSurfaceVariant.panel,
          borderRadius: borderRadius,
          padding: EdgeInsets.fromLTRB(
            AppDimensions.paddingL,
            AppDimensions.paddingM,
            AppDimensions.paddingL,
            AppDimensions.paddingL + MediaQuery.paddingOf(context).bottom,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: maxHeight.clamp(120.0, 1200.0),
            ),
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurfaceVariant.withValues(alpha: 0.28),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  if (title != null) ...[
                    const SizedBox(height: AppDimensions.spaceM),
                    Text(
                      title!,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppDimensions.spaceL),
                  ] else
                    const SizedBox(height: AppDimensions.spaceM),
                  child,
                ],
              ),
            ),
          ),
        );

        return Padding(
          padding: EdgeInsets.only(bottom: bottomInset),
          child: AppLayoutItemBuilder<Widget>(
            narrow: () => sheet,
            wide: () => Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.spaceL),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 640),
                  child: sheet,
                ),
              ),
            ),
          )(context),
        );
      },
    );
  }
}
