import 'package:flutter/material.dart';

import '../utils/responsive.dart';
import 'app_colors.dart';
import 'app_radii.dart';
import 'app_spacing.dart';
import 'app_text_styles.dart';

/// Centralized light and dark themes — "Institutional Sovereign".
///
/// This is the only place `ThemeData` is constructed. Component styling
/// follows `DESIGN.md`:
/// * 44px controls, 20px cards, 10px inputs/buttons, 999px pills;
/// * elevation via 1px hairline strokes, not diffuse shadows;
/// * dark mode inverts the primary action to honey gold.
abstract final class AppTheme {
  static ThemeData get light => _buildTheme(AppColors.lightScheme);

  static ThemeData get dark => _buildTheme(AppColors.darkScheme);

  static ThemeData _buildTheme(ColorScheme scheme) {
    final brightness = scheme.brightness;
    final isDark = brightness == Brightness.dark;
    final textTheme = AppTextStyles.textTheme(scheme);
    final stroke = AppColors.stroke(brightness);
    final subtle = AppColors.subtle(brightness);

    OutlineInputBorder inputBorder(Color color, {double width = 1}) =>
        OutlineInputBorder(
          borderRadius: AppRadii.elementRadius,
          borderSide: BorderSide(color: color, width: width),
        );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: AppColors.canvas(brightness),
      canvasColor: AppColors.card(brightness),
      dividerColor: stroke,
      visualDensity: VisualDensity.standard,
      materialTapTargetSize: MaterialTapTargetSize.padded,

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.card(brightness),
        foregroundColor: AppColors.textPrimary(brightness),
        surfaceTintColor: AppColors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge,
        iconTheme: IconThemeData(color: AppColors.textPrimary(brightness)),
      ),

      cardTheme: CardThemeData(
        elevation: 0,
        color: AppColors.card(brightness),
        surfaceTintColor: AppColors.transparent,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.cardRadius,
          side: BorderSide(color: stroke),
        ),
      ),

      dividerTheme: DividerThemeData(
        color: stroke,
        thickness: AppDimensions.hairline,
        space: AppSpacing.lg,
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(AppDimensions.buttonHeight),
          backgroundColor: AppColors.primaryAction(brightness),
          foregroundColor: AppColors.onPrimaryAction(brightness),
          textStyle: textTheme.labelLarge,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadii.elementRadius,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(AppDimensions.buttonHeight),
          foregroundColor: AppColors.textPrimary(brightness),
          textStyle: textTheme.labelLarge,
          side: BorderSide(color: stroke),
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadii.elementRadius,
          ),
        ),
      ),

      // Destructive actions: tinted surface, danger text, danger border.
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.primary,
          textStyle: textTheme.labelLarge,
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadii.elementRadius,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.inputSurface(brightness),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: AppSpacing.md,
        ),
        constraints: const BoxConstraints(minHeight: AppDimensions.inputHeight),
        border: inputBorder(stroke),
        enabledBorder: inputBorder(stroke),
        focusedBorder: inputBorder(
          AppColors.focusRing,
          width: AppDimensions.focusRingWidth,
        ),
        errorBorder: inputBorder(AppColors.dangerText(brightness)),
        focusedErrorBorder: inputBorder(
          AppColors.dangerText(brightness),
          width: AppDimensions.focusRingWidth,
        ),
        labelStyle: textTheme.bodyMedium?.copyWith(
          color: AppColors.textMuted(brightness),
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: AppColors.textMuted(brightness),
        ),
        errorStyle: textTheme.bodySmall?.copyWith(
          color: AppColors.dangerText(brightness),
        ),
        suffixIconColor: AppColors.textMuted(brightness),
        prefixIconColor: AppColors.textMuted(brightness),
      ),

      navigationBarTheme: NavigationBarThemeData(
        height: AppDimensions.minTapTarget + AppSpacing.xl,
        backgroundColor: AppColors.card(brightness),
        surfaceTintColor: AppColors.transparent,
        indicatorColor: AppColors.brandTintSurfaceLight.withValues(
          alpha: isDark ? 0.24 : 1,
        ),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => textTheme.labelSmall?.copyWith(
            color: states.contains(WidgetState.selected)
                ? AppColors.textPrimary(brightness)
                : AppColors.textMuted(brightness),
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            size: AppDimensions.iconMedium,
            color: states.contains(WidgetState.selected)
                ? AppColors.textPrimary(brightness)
                : AppColors.textMuted(brightness),
          ),
        ),
      ),

      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: AppColors.card(brightness),
        indicatorColor: AppColors.brandTintSurfaceLight.withValues(
          alpha: isDark ? 0.24 : 1,
        ),
        selectedIconTheme: IconThemeData(
          size: AppDimensions.iconMedium,
          color: AppColors.textPrimary(brightness),
        ),
        unselectedIconTheme: IconThemeData(
          size: AppDimensions.iconMedium,
          color: AppColors.textMuted(brightness),
        ),
        selectedLabelTextStyle: textTheme.labelSmall?.copyWith(
          color: AppColors.textPrimary(brightness),
        ),
        unselectedLabelTextStyle: textTheme.labelSmall?.copyWith(
          color: AppColors.textMuted(brightness),
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: scheme.onInverseSurface,
        ),
        actionTextColor: scheme.onInverseSurface,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadii.elementRadius,
        ),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.card(brightness),
        surfaceTintColor: AppColors.transparent,
        elevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.cardRadius),
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.card(brightness),
        surfaceTintColor: AppColors.transparent,
        elevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.topSheet),
      ),

      // Status chips: 24px tall, fully rounded, semantic container + dark text.
      chipTheme: ChipThemeData(
        backgroundColor: subtle,
        side: BorderSide(color: stroke),
        labelStyle: textTheme.labelSmall,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.chipRadius),
      ),

      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColors.primaryAction(brightness),
        linearTrackColor: subtle,
        circularTrackColor: subtle,
      ),

      checkboxTheme: CheckboxThemeData(
        side: BorderSide(color: stroke, width: 1),
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadii.checkboxRadius,
        ),
        fillColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppColors.primaryAction(brightness)
              : AppColors.transparent,
        ),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryAction(brightness),
        foregroundColor: AppColors.onPrimaryAction(brightness),
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadii.elementRadius,
        ),
      ),

      listTileTheme: ListTileThemeData(
        iconColor: AppColors.textMuted(brightness),
        titleTextStyle: textTheme.titleMedium,
        subtitleTextStyle: textTheme.bodySmall,
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.rowRadius),
      ),

      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: isDark ? AppColors.subtleDark : AppColors.textPrimaryLight,
          borderRadius: AppRadii.elementRadius,
        ),
        textStyle: textTheme.bodySmall?.copyWith(color: AppColors.cardLight),
      ),
    );
  }
}
