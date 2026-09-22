import 'package:flutter/material.dart';

class AppDimensions {
  AppDimensions._();

  // Padding & Margins
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;
  static const double paddingXXL = 48.0;

  // Border Radius (36px app-wide; nav bar uses its own radius)
  static const double radius = 36.0;
  static const double radiusXS = radius;
  static const double radiusS = radius;
  static const double radiusM = radius;
  static const double radiusL = radius;
  static const double radiusXL = radius;
  static const double radiusCircular = radius;

  // Icon Sizes
  static const double iconXS = 16.0;
  static const double iconS = 20.0;
  static const double iconM = 24.0;
  static const double iconL = 32.0;
  static const double iconXL = 48.0;
  static const double iconXXL = 64.0;

  // Button Heights
  static const double buttonHeightS = 36.0;
  static const double buttonHeightM = 48.0;
  static const double buttonHeightL = 56.0;

  // Card & Container
  static const double cardElevation = 2.0;
  static const double cardElevationHovered = 4.0;
  static const double cardElevationPressed = 1.0;

  static const double containerMinHeight = 56.0;
  static const double listItemHeight = 72.0;
  static const double appBarHeight = 56.0;
  static const double bottomNavHeight = 80.0;

  // Spacing
  static const double spaceXS = 4.0;
  static const double spaceS = 8.0;
  static const double spaceM = 16.0;
  static const double spaceL = 24.0;
  static const double spaceXL = 32.0;
  static const double spaceXXL = 48.0;

  // Form Elements
  static const double textFieldHeight = 56.0;
  static const double textFieldBorderWidth = 1.0;
  static const double textFieldBorderWidthFocused = 2.0;

  // Divider
  static const double dividerThickness = 1.0;
  static const double dividerIndent = 16.0;

  // Animation Durations (in milliseconds)
  static const int animationDurationFast = 150;
  static const int animationDurationNormal = 300;
  static const int animationDurationSlow = 500;

  // Screen Breakpoints
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 900.0;
  static const double desktopBreakpoint = 1200.0;

  // App Specific Dimensions
  static const double expenseCardHeight = 80.0;
  static const double categoryIconSize = 40.0;
  static const double chartHeight = 200.0;
  static const double summaryCardHeight = 120.0;
  static const double fabSize = 56.0;

  // Edge Insets
  static const EdgeInsets paddingAllXS = EdgeInsets.all(paddingXS);
  static const EdgeInsets paddingAllS = EdgeInsets.all(paddingS);
  static const EdgeInsets paddingAllM = EdgeInsets.all(paddingM);
  static const EdgeInsets paddingAllL = EdgeInsets.all(paddingL);
  static const EdgeInsets paddingAllXL = EdgeInsets.all(paddingXL);

  static const EdgeInsets paddingHorizontalS = EdgeInsets.symmetric(
    horizontal: paddingS,
  );
  static const EdgeInsets paddingHorizontalM = EdgeInsets.symmetric(
    horizontal: paddingM,
  );
  static const EdgeInsets paddingHorizontalL = EdgeInsets.symmetric(
    horizontal: paddingL,
  );

  static const EdgeInsets paddingVerticalS = EdgeInsets.symmetric(
    vertical: paddingS,
  );
  static const EdgeInsets paddingVerticalM = EdgeInsets.symmetric(
    vertical: paddingM,
  );
  static const EdgeInsets paddingVerticalL = EdgeInsets.symmetric(
    vertical: paddingL,
  );

  // Border Radius
  static const BorderRadius borderRadius = BorderRadius.all(
    Radius.circular(radius),
  );
  static const BorderRadius borderRadiusXS = borderRadius;
  static const BorderRadius borderRadiusS = borderRadius;
  static const BorderRadius borderRadiusM = borderRadius;
  static const BorderRadius borderRadiusL = borderRadius;
  static const BorderRadius borderRadiusXL = borderRadius;

  // Responsive helper methods
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktopBreakpoint;
  }

  static double getResponsivePadding(BuildContext context) {
    if (isMobile(context)) return paddingM;
    if (isTablet(context)) return paddingL;
    return paddingXL;
  }
}
