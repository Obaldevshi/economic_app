import 'package:flutter/material.dart';
import 'package:mobile_template/app/layout/app_layout_item_builder.dart';
import 'package:mobile_template/app/theme/app_dimensions.dart';
import 'package:mobile_template/core/utils/keyboard_inset.dart';
import 'package:mobile_template/presentation/widgets/common/glass_surface.dart';
import 'package:mobile_template/presentation/widgets/layout/scroll_shell.dart';

/// Общая оболочка входа и регистрации с устойчивым поведением клавиатуры.
class AuthScrollScaffold extends StatefulWidget {
  const AuthScrollScaffold({required this.hero, required this.form, super.key});

  final Widget hero;
  final Widget form;

  @override
  State<AuthScrollScaffold> createState() => _AuthScrollScaffoldState();
}

class _AuthScrollScaffoldState extends State<AuthScrollScaffold> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    if (!mounted || !_scrollController.hasClients) return;
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomSafe = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: ScrollShell.headerBackground,
      resizeToAvoidBottomInset: false,
      body: ColoredBox(
        color: ScrollShell.headerBackground,
        child: KeyboardInsetBuilder(
          onOpened: () => KeyboardInset.ensureFocusedVisible(context),
          onClosed: _scrollToTop,
          builder: (context, keyboardInset) {
            return Padding(
              padding: EdgeInsets.only(bottom: keyboardInset),
              child: SafeArea(
                bottom: false,
                child: AppLayoutItemBuilder<Widget>(
                  narrow: () => _buildNarrow(
                    keyboardInset: keyboardInset,
                    bottomSafe: bottomSafe,
                  ),
                  wide: () => _buildWide(
                    keyboardInset: keyboardInset,
                    bottomSafe: bottomSafe,
                  ),
                )(context),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildNarrow({
    required double keyboardInset,
    required double bottomSafe,
  }) {
    return CustomScrollView(
      controller: _scrollController,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      slivers: [
        SliverToBoxAdapter(child: widget.hero),
        SliverFillRemaining(
          hasScrollBody: false,
          fillOverscroll: true,
          child: _buildFormPanel(
            keyboardInset: keyboardInset,
            bottomSafe: bottomSafe,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppDimensions.radius),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWide({
    required double keyboardInset,
    required double bottomSafe,
  }) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: widget.hero,
            ),
          ),
        ),
        Expanded(
          flex: 6,
          child: CustomScrollView(
            controller: _scrollController,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: _buildFormPanel(
                  keyboardInset: keyboardInset,
                  bottomSafe: bottomSafe,
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(AppDimensions.radius),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFormPanel({
    required double keyboardInset,
    required double bottomSafe,
    required BorderRadius borderRadius,
  }) {
    return GlassSurface(
      variant: GlassSurfaceVariant.panel,
      showBorder: false,
      borderRadius: borderRadius,
      padding: EdgeInsets.fromLTRB(
        AppDimensions.paddingL,
        AppDimensions.paddingL,
        AppDimensions.paddingL,
        AppDimensions.paddingL +
            (keyboardInset > 0 ? AppDimensions.spaceM : bottomSafe),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: SizedBox(width: double.infinity, child: widget.form),
        ),
      ),
    );
  }
}
