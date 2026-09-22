import 'package:mobile_template/app/theme/app_dimensions.dart';
import 'package:mobile_template/core/extensions/build_context_extensions.dart';
import 'package:mobile_template/generated/assets.gen.dart';
import 'package:mobile_template/presentation/widgets/common/app_svg_icon.dart';
import 'package:mobile_template/presentation/widgets/common/confirmation_dialog.dart';
import 'package:mobile_template/presentation/widgets/common/global_button.dart';
import 'package:mobile_template/presentation/widgets/common/global_text_form_field.dart';
import 'package:mobile_template/presentation/widgets/common/glass_surface_card.dart';
import 'package:flutter/material.dart';

class UiKitComponentsDemo extends StatefulWidget {
  const UiKitComponentsDemo({required this.demoInputController, super.key});

  final TextEditingController demoInputController;

  @override
  State<UiKitComponentsDemo> createState() => _UiKitComponentsDemoState();
}

class _UiKitComponentsDemoState extends State<UiKitComponentsDemo> {
  bool _isLoading = false;

  Future<void> _showDialog() async {
    await ConfirmationDialog.show(
      context,
      title: context.l10n.homeDialogDemoTitle,
      content: context.l10n.homeDialogDemoContent,
      confirmText: context.l10n.ok,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GlobalButton(
          text: l10n.homeToggleLoading,
          isLoading: _isLoading,
          onPressed: () => setState(() => _isLoading = !_isLoading),
        ),
        const SizedBox(height: AppDimensions.spaceM),
        OutlinedButton(
          onPressed: _showDialog,
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(AppDimensions.buttonHeightM),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radius),
            ),
          ),
          child: Text(l10n.homeShowDialog),
        ),
        const SizedBox(height: AppDimensions.spaceL),
        GlobalTextFormField(
          controller: widget.demoInputController,
          labelText: l10n.homeDemoInputLabel,
          hintText: l10n.homeDemoInputHint,
        ),
        const SizedBox(height: AppDimensions.spaceL),
        Row(
          children: [
            Expanded(
              child: _GlassVariantPreview(
                label: l10n.homeGlassOnLight,
                variant: GlassSurfaceVariant.onLight,
              ),
            ),
            const SizedBox(width: AppDimensions.spaceS),
            Expanded(
              child: _GlassVariantPreview(
                label: l10n.homeGlassPanel,
                variant: GlassSurfaceVariant.panel,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.spaceS),
        _GlassVariantPreview(
          label: l10n.homeGlassOnGradient,
          variant: GlassSurfaceVariant.onGradient,
        ),
        const SizedBox(height: AppDimensions.spaceL),
        Text(
          'Icons',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppDimensions.spaceS),
        Wrap(
          spacing: AppDimensions.spaceS,
          runSpacing: AppDimensions.spaceS,
          children: [
            _IconTile(icon: Assets.icons.home),
            _IconTile(icon: Assets.icons.category),
            _IconTile(icon: Assets.icons.user),
            _IconTile(icon: Assets.icons.plus),
            _IconTile(icon: Assets.icons.edit),
            _IconTile(icon: Assets.icons.delete),
          ],
        ),
      ],
    );
  }
}

class _GlassVariantPreview extends StatelessWidget {
  const _GlassVariantPreview({required this.label, required this.variant});

  final String label;
  final GlassSurfaceVariant variant;

  @override
  Widget build(BuildContext context) {
    return GlassSurfaceCard(
      variant: variant,
      showBorder: true,
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: Theme.of(
          context,
        ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _IconTile extends StatelessWidget {
  const _IconTile({required this.icon});

  final SvgGenImage icon;

  @override
  Widget build(BuildContext context) {
    return GlassSurfaceCard(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      child: AppSvgIcon(
        icon: icon,
        color: Theme.of(context).colorScheme.primary,
        size: 24,
      ),
    );
  }
}
