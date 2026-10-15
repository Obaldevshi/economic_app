import 'package:mobile_template/core/extensions/build_context_extensions.dart';
import 'package:mobile_template/core/services/theme_service.dart';
import 'package:mobile_template/presentation/widgets/common/glass_surface_card.dart';
import 'package:mobile_template/presentation/widgets/ui_kit/ui_kit_segmented_control.dart';
import 'package:flutter/material.dart';

class UiKitThemeSwitcher extends StatelessWidget {
  const UiKitThemeSwitcher({required this.themeService, super.key});

  final ThemeService themeService;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeService,
      builder: (context, _) {
        return GlassSurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.palette_outlined,
                    size: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    context.l10n.appearance,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              UiKitSegmentedControl<ThemeMode>(
                selected: themeService.themeMode,
                onSelected: themeService.setThemeMode,
                options: [
                  UiKitSegmentOption(
                    value: ThemeMode.system,
                    label: context.l10n.themeSystem,
                    icon: Icons.brightness_auto_rounded,
                  ),
                  UiKitSegmentOption(
                    value: ThemeMode.light,
                    label: context.l10n.themeLight,
                    icon: Icons.light_mode_rounded,
                  ),
                  UiKitSegmentOption(
                    value: ThemeMode.dark,
                    label: context.l10n.themeDark,
                    icon: Icons.dark_mode_rounded,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _PaletteEditor(
                service: themeService,
                brightness: Brightness.light,
              ),
              _PaletteEditor(
                service: themeService,
                brightness: Brightness.dark,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PaletteEditor extends StatefulWidget {
  const _PaletteEditor({required this.service, required this.brightness});
  final ThemeService service;
  final Brightness brightness;
  @override
  State<_PaletteEditor> createState() => _PaletteEditorState();
}

class _PaletteEditorState extends State<_PaletteEditor> {
  late final _hex = TextEditingController();
  String? _error;
  Color get _color =>
      (widget.brightness == Brightness.light
          ? widget.service.lightSeed
          : widget.service.darkSeed) ??
      const Color(0xFF965238);
  @override
  void initState() {
    super.initState();
    _updateHex();
    final draft = widget.service.paletteDraft(widget.brightness);
    if (draft != null) _hex.text = draft;
  }

  void _updateHex() => _hex.text = _color
      .toARGB32()
      .toRadixString(16)
      .substring(2)
      .toUpperCase();
  @override
  void dispose() {
    _hex.dispose();
    super.dispose();
  }

  Future<void> _select(Color? color) async {
    widget.service.setPaletteDraft(widget.brightness, null);
    await widget.service.setSeed(widget.brightness, color);
    if (mounted) {
      setState(() {
        _error = null;
        _updateHex();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final hsl = HSLColor.fromColor(_color);
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      leading: Icon(
        widget.brightness == Brightness.light
            ? Icons.light_mode_outlined
            : Icons.dark_mode_outlined,
        color: _color,
      ),
      title: Text(
        widget.brightness == Brightness.light
            ? context.l10n.lightPalette
            : context.l10n.darkPalette,
      ),
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final color in const [
              Color(0xFF965238),
              Color(0xFF355C7D),
              Color(0xFF496D4A),
              Color(0xFF77558D),
              Color(0xFFAD3D54),
              Color(0xFF98711A),
              Color(0xFF287B7C),
              Color(0xFF5C6270),
            ])
              IconButton(
                tooltip:
                    '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}',
                onPressed: () => _select(color),
                style: IconButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: color.computeLuminance() > 0.4
                      ? Colors.black
                      : Colors.white,
                ),
                icon: Icon(
                  color == _color ? Icons.check : Icons.circle_outlined,
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _hex,
          onChanged: (text) =>
              widget.service.setPaletteDraft(widget.brightness, text),
          decoration: InputDecoration(
            labelText: context.l10n.customColor,
            prefixText: '#',
            errorText: _error,
            suffixIcon: IconButton(
              tooltip: context.l10n.save,
              icon: const Icon(Icons.check),
              onPressed: _submitHex,
            ),
          ),
          maxLength: 6,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _submitHex(),
        ),
        Slider(
          label: context.l10n.colorHue,
          value: hsl.hue,
          max: 360,
          onChanged: (v) => _select(hsl.withHue(v).toColor()),
        ),
        TextButton(
          onPressed: () => _select(null),
          child: Text(context.l10n.resetPalette),
        ),
      ],
    );
  }

  void _submitHex() {
    final raw = _hex.text.trim();
    if (!RegExp(r'^[0-9a-fA-F]{6}$').hasMatch(raw)) {
      setState(() => _error = context.l10n.invalidColor);
      return;
    }
    _select(Color(int.parse('FF$raw', radix: 16)));
  }
}
