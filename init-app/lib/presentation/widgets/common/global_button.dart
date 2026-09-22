import 'package:mobile_template/app/theme/app_colors.dart';
import 'package:mobile_template/app/theme/app_dimensions.dart';
import 'package:mobile_template/app/theme/app_text_styles.dart';
import 'package:mobile_template/presentation/widgets/common/glass_surface.dart';
import 'package:flutter/material.dart';

class GlobalButton extends StatelessWidget {
  const GlobalButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return GlassSurface(
      variant: GlassSurfaceVariant.onGradient,
      borderRadius: AppDimensions.borderRadius,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: (isLoading || !isEnabled) ? null : onPressed,
          borderRadius: AppDimensions.borderRadius,
          child: Container(
            height: AppDimensions.buttonHeightL,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              borderRadius: AppDimensions.borderRadius,
              color: AppColors.primary,
            ),
            child: isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(text, style: AppTextStyles.buttonText),
          ),
        ),
      ),
    );
  }
}
