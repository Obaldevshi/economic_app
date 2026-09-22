import 'package:mobile_template/app/theme/app_colors.dart';
import 'package:mobile_template/app/layout/app_layout_item_builder.dart';
import 'package:mobile_template/app/theme/app_dimensions.dart';
import 'package:mobile_template/app/theme/app_glass.dart';
import 'package:mobile_template/core/utils/keyboard_inset.dart';
import 'package:mobile_template/presentation/widgets/common/glass_surface.dart';
import 'package:flutter/material.dart';

class _ShellScrollBehavior extends ScrollBehavior {
  const _ShellScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics());
  }
}

/// Dashboard-style page shell with a solid header and pinned toolbar.
///
/// Header and panel corner fill use a single flat [headerBackground] color.
/// Gradients are intentionally not used here — they cause seams at rounded corners.
class ScrollShell extends StatefulWidget {
  const ScrollShell({
    required this.title,
    required this.headerContent,
    required this.body,
    this.actions = const [],
    this.leading,
    this.onRefresh,
    this.isLoading = false,
    this.expandedHeaderHeight = 40,
    super.key,
  });

  final String title;
  final Widget headerContent;
  final List<Widget> actions;
  final Widget? leading;
  final Widget body;
  final Future<void> Function()? onRefresh;
  final bool isLoading;

  /// Height of the flexible header area below the toolbar (search field, subtitle, etc.).
  final double expandedHeaderHeight;

  static const double toolbarHeight = 52;
  static const double _panelRadius = AppDimensions.radius;
  static const double _navBarHeight = 64;
  static const double _navBarBottomMargin = 10;

  /// Flat header/panel-corner color. Gradients are not allowed in this shell.
  static const Color headerBackground = AppColors.primary;

  static bool isKeyboardOpen(BuildContext context) =>
      KeyboardInset.resolve(context) > 0;

  /// Bottom padding so content is not hidden under [GlassBottomNavBar].
  static double bottomNavInset(BuildContext context) {
    if (isKeyboardOpen(context)) return 0;
    return AppLayoutItemBuilder<double>(
      narrow: () =>
          _navBarHeight +
          _navBarBottomMargin +
          MediaQuery.paddingOf(context).bottom,
      wide: () => 0,
    )(context);
  }

  /// Foreground color for header title/icons (white → onSurface while collapsing).
  static Color headerForegroundColor(BuildContext context, double collapseT) {
    final scheme = Theme.of(context).colorScheme;
    return Color.lerp(Colors.white, scheme.onSurface, collapseT) ??
        Colors.white;
  }

  @override
  State<ScrollShell> createState() => _ScrollShellState();
}

class _ScrollShellState extends State<ScrollShell> {
  final _scrollController = ScrollController();
  double _collapseT = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients || !mounted) return;

    final topInset = MediaQuery.paddingOf(context).top;
    final expandedHeight =
        widget.expandedHeaderHeight + topInset + ScrollShell.toolbarHeight;
    final range = expandedHeight - ScrollShell.toolbarHeight;
    if (range <= 0) return;

    final progress = (_scrollController.offset / range).clamp(0.0, 1.0);
    if ((progress - _collapseT).abs() < 0.02) return;
    setState(() => _collapseT = progress);
  }

  double _expandedHeight(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    return widget.expandedHeaderHeight + topInset + ScrollShell.toolbarHeight;
  }

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    final expandedHeight = _expandedHeight(context);
    final surfaceColor = Theme.of(context).colorScheme.surface;
    final isWide = AppLayoutItemBuilder<bool>.values(narrow: false, wide: true)(
      context,
    );
    final foregroundColor = ScrollShell.headerForegroundColor(
      context,
      _collapseT,
    );
    final screenHeight = MediaQuery.sizeOf(context).height;
    final panelTopRadius = isWide
        ? 0.0
        : ScrollShell._panelRadius * (1 - _collapseT);
    final horizontalInset = AppLayoutItemBuilder<double>.values(
      narrow: AppDimensions.paddingM,
      wide: AppDimensions.paddingXL,
    )(context);
    final shell = Stack(
      fit: StackFit.expand,
      children: [
        // При нижнем overscroll видна поверхность страницы, а не фон header.
        ColoredBox(color: surfaceColor),
        if (!isWide)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: expandedHeight,
            child: const ColoredBox(color: ScrollShell.headerBackground),
          ),
        KeyboardInsetBuilder(
          onOpened: () => KeyboardInset.ensureFocusedVisible(context),
          builder: (context, keyboardInset) {
            final bottomInset = keyboardInset > 0
                ? 0.0
                : ScrollShell.bottomNavInset(context);
            final minBodyHeight = (screenHeight - keyboardInset).clamp(
              0.0,
              screenHeight,
            );

            return Padding(
              // Уменьшаем viewport снизу, не полагаясь на resize Scaffold.
              padding: EdgeInsets.only(bottom: keyboardInset),
              child: CustomScrollView(
                controller: _scrollController,
                scrollBehavior: const _ShellScrollBehavior(),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                slivers: [
                  if (isWide)
                    SliverToBoxAdapter(
                      child: _WebShellHeader(
                        title: widget.title,
                        leading: widget.leading,
                        actions: widget.actions,
                        headerContent: widget.expandedHeaderHeight > 40
                            ? widget.headerContent
                            : null,
                        horizontalInset: horizontalInset,
                      ),
                    )
                  else
                    SliverAppBar(
                      pinned: true,
                      floating: false,
                      snap: false,
                      stretch: true,
                      expandedHeight: expandedHeight,
                      collapsedHeight: ScrollShell.toolbarHeight,
                      toolbarHeight: ScrollShell.toolbarHeight,
                      backgroundColor: Colors.transparent,
                      surfaceTintColor: Colors.transparent,
                      elevation: 0,
                      scrolledUnderElevation: 0,
                      forceElevated: false,
                      centerTitle: false,
                      title: const SizedBox.shrink(),
                      automaticallyImplyLeading: false,
                      leading: widget.leading == null
                          ? null
                          : IconTheme(
                              data: IconThemeData(color: foregroundColor),
                              child: widget.leading!,
                            ),
                      actions: widget.actions.isEmpty
                          ? null
                          : [
                              for (final action in widget.actions)
                                IconTheme(
                                  data: IconThemeData(color: foregroundColor),
                                  child: action,
                                ),
                            ],
                      flexibleSpace: _ShellFlexibleHeader(
                        collapseT: _collapseT,
                        title: widget.title,
                        headerContent: widget.headerContent,
                        toolbarHeight: ScrollShell.toolbarHeight,
                        titleLeftInset: widget.leading != null
                            ? 52.0
                            : horizontalInset,
                        contentHorizontalInset: horizontalInset,
                      ),
                    ),
                  SliverToBoxAdapter(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: minBodyHeight),
                      child: ColoredBox(
                        color: !isWide && panelTopRadius > 0
                            ? ScrollShell.headerBackground
                            : surfaceColor,
                        child: GlassSurface(
                          variant: GlassSurfaceVariant.panel,
                          showBorder: false,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(panelTopRadius),
                          ),
                          padding: EdgeInsets.fromLTRB(
                            horizontalInset,
                            AppDimensions.paddingM,
                            horizontalInset,
                            AppDimensions.paddingM + bottomInset,
                          ),
                          child: Stack(
                            children: [
                              widget.body,
                              if (widget.isLoading)
                                Positioned.fill(
                                  child: AbsorbPointer(
                                    child: ColoredBox(
                                      color: surfaceColor.withValues(
                                        alpha: 0.72,
                                      ),
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );

    if (widget.onRefresh == null) return shell;

    return RefreshIndicator(
      onRefresh: widget.onRefresh!,
      color: AppColors.primary,
      displacement: ScrollShell.toolbarHeight + topInset + 8,
      notificationPredicate: (notification) => notification.depth <= 1,
      child: shell,
    );
  }
}

class _WebShellHeader extends StatelessWidget {
  const _WebShellHeader({
    required this.title,
    required this.actions,
    required this.horizontalInset,
    this.leading,
    this.headerContent,
  });

  final String title;
  final List<Widget> actions;
  final double horizontalInset;
  final Widget? leading;
  final Widget? headerContent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        horizontalInset,
        AppDimensions.paddingXL,
        horizontalInset,
        AppDimensions.paddingL,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              if (leading != null) ...[
                IconTheme(
                  data: IconThemeData(color: theme.colorScheme.onSurface),
                  child: leading!,
                ),
                const SizedBox(width: AppDimensions.spaceS),
              ],
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              for (final action in actions)
                IconTheme(
                  data: IconThemeData(color: theme.colorScheme.onSurface),
                  child: action,
                ),
            ],
          ),
          if (headerContent != null) ...[
            const SizedBox(height: AppDimensions.spaceM),
            headerContent!,
          ],
        ],
      ),
    );
  }
}

class _ShellFlexibleHeader extends StatelessWidget {
  const _ShellFlexibleHeader({
    required this.collapseT,
    required this.title,
    required this.headerContent,
    required this.toolbarHeight,
    required this.titleLeftInset,
    required this.contentHorizontalInset,
  });

  final double collapseT;
  final String title;
  final Widget headerContent;
  final double toolbarHeight;
  final double titleLeftInset;
  final double contentHorizontalInset;

  @override
  Widget build(BuildContext context) {
    final settings = context
        .dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
    final theme = Theme.of(context);
    final topInset = MediaQuery.paddingOf(context).top;
    final barHeight = topInset + toolbarHeight;

    final t = settings == null
        ? collapseT
        : () {
            final range = settings.maxExtent - settings.minExtent;
            if (range <= 0) return collapseT;
            return (1 - (settings.currentExtent - settings.minExtent) / range)
                .clamp(0.0, 1.0);
          }();

    final foregroundColor = ScrollShell.headerForegroundColor(context, t);
    final expandedOpacity = (1 - t).clamp(0.0, 1.0);
    final toolbarOpacity = t.clamp(0.0, 1.0);

    return Stack(
      fit: StackFit.expand,
      children: [
        Opacity(
          opacity: expandedOpacity,
          child: const ColoredBox(color: ScrollShell.headerBackground),
        ),
        if (expandedOpacity > 0)
          Positioned(
            left: contentHorizontalInset,
            right: contentHorizontalInset,
            bottom: AppDimensions.paddingS,
            child: Opacity(
              opacity: (1 - t * 1.4).clamp(0.0, 1.0),
              child: headerContent,
            ),
          ),
        if (toolbarOpacity > 0)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: barHeight,
            child: _SolidToolbar(height: barHeight, opacity: toolbarOpacity),
          ),
        Positioned(
          top: topInset,
          left: titleLeftInset,
          right: AppDimensions.paddingM,
          height: toolbarHeight,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                color: foregroundColor,
                fontWeight: FontWeight.w700,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}

class _SolidToolbar extends StatelessWidget {
  const _SolidToolbar({required this.height, required this.opacity});

  final double height;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Color.lerp(
          ScrollShell.headerBackground,
          AppGlass.fill(context),
          opacity,
        ),
        border: Border(
          bottom: BorderSide(
            color: AppGlass.border(context).withValues(alpha: opacity),
            width: AppGlass.borderWidth,
          ),
        ),
      ),
      child: SizedBox(height: height),
    );
  }
}
