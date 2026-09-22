import 'package:mobile_template/app/theme/app_colors.dart';
import 'package:mobile_template/app/theme/app_dimensions.dart';
import 'package:mobile_template/app/theme/app_glass.dart';
import 'package:mobile_template/core/utils/keyboard_inset.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GlobalTextFormField extends StatefulWidget {
  const GlobalTextFormField({
    super.key,
    required this.controller,
    required this.labelText,
    this.hintText,
    this.prefixText,
    this.keyboardType,
    this.maxLines = 1,
    this.validator,
    this.onChanged,
    this.enabled = true,
    this.suffixIcon,
    this.obscureText = false,
    this.inputFormatters,
    this.maxLength,
    this.autofocus = false,
  });

  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final String? prefixText;
  final TextInputType? keyboardType;
  final int? maxLines;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool enabled;
  final Widget? suffixIcon;
  final bool obscureText;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final bool autofocus;

  @override
  State<GlobalTextFormField> createState() => _GlobalTextFormFieldState();
}

class _GlobalTextFormFieldState extends State<GlobalTextFormField> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()..addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_onFocusChange)
      ..dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) KeyboardInset.ensureFocusedVisible(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppGlass.isDark(context);
    final fill = isDark
        ? Colors.white.withValues(alpha: 0.06)
        : Colors.white.withValues(alpha: 0.55);
    final border = AppGlass.inputBorder(context);

    return TextFormField(
      controller: widget.controller,
      focusNode: _focusNode,
      keyboardType: widget.keyboardType,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      enabled: widget.enabled,
      obscureText: widget.obscureText,
      onChanged: widget.onChanged,
      inputFormatters: widget.inputFormatters,
      autofocus: widget.autofocus,
      onTapOutside: (_) => _focusNode.unfocus(),
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        prefixText: widget.prefixText,
        suffixIcon: widget.suffixIcon,
        filled: true,
        fillColor: fill,
        border: OutlineInputBorder(
          borderRadius: AppDimensions.borderRadiusM,
          borderSide: BorderSide(color: border, width: AppGlass.borderWidth),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppDimensions.borderRadiusM,
          borderSide: BorderSide(color: border, width: AppGlass.borderWidth),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppDimensions.borderRadiusM,
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: AppDimensions.borderRadiusM,
          borderSide: BorderSide(color: border.withValues(alpha: 0.5)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppDimensions.borderRadiusM,
          borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppDimensions.borderRadiusM,
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
            width: 1.5,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      validator: widget.validator,
    );
  }
}
