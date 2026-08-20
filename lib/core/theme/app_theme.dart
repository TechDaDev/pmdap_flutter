import 'package:flutter/material.dart';

/// PMDAP brand palette — calm, secure, medical but not hospital.
class AppColors {
  AppColors._();

  // Light
  static const Color primaryNavy = Color(0xFF0B3B75);
  static const Color primaryBlue = Color(0xFF125CA8);
  static const Color brandTeal = Color(0xFF16B8B2);
  static const Color brandCyan = Color(0xFF4BC9CE);
  static const Color lightBlue = Color(0xFFEAF4FB);
  static const Color paleTeal = Color(0xFFE9F8F7);
  static const Color pageBg = Color(0xFFF6F8FB);
  static const Color surface = Color(0xFFFFFFFF);

  static const Color textPrimary = Color(0xFF142033);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color border = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFEDF1F5);

  static const Color success = Color(0xFF159A70);
  static const Color successBg = Color(0xFFE8F7F1);
  static const Color warning = Color(0xFFB7791F);
  static const Color warningBg = Color(0xFFFFF7E8);
  static const Color error = Color(0xFFC83C3C);
  static const Color errorBg = Color(0xFFFDEEEE);
  static const Color info = Color(0xFF2563A7);
  static const Color infoBg = Color(0xFFEAF3FB);

  // Dark
  static const Color darkBg = Color(0xFF0F1720);
  static const Color darkSurface = Color(0xFF16212D);
  static const Color darkElevated = Color(0xFF1D2B38);
  static const Color darkTextPrimary = Color(0xFFF4F7FA);
  static const Color darkTextSecondary = Color(0xFFAAB7C4);
  static const Color darkBorder = Color(0xFF2A3948);
  static const Color darkPrimaryBlue = Color(0xFF5AA9F0);
  static const Color darkTeal = Color(0xFF36C9C3);
  static const Color darkSuccess = Color(0xFF4FD3A3);
  static const Color darkWarning = Color(0xFFE3B45B);
  static const Color darkError = Color(0xFFF27676);
}

/// Consistent spacing scale.
class AppSpacing {
  AppSpacing._();
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;
  static const double huge = 40;
  static const double pageH = 20;
}

/// Corner radius scale.
class AppRadii {
  AppRadii._();
  static const double input = 12;
  static const double button = 12;
  static const double card = 16;
  static const double largeCard = 20;
  static const double sheet = 24;
  static const double badge = 999;
}

/// Typography scale.
class AppTypography {
  AppTypography._();

  static TextStyle pageTitle(BuildContext context) => TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: Theme.of(context).colorScheme.onSurface,
  );

  static TextStyle sectionTitle(BuildContext context) => TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: Theme.of(context).colorScheme.onSurface,
  );

  static TextStyle cardTitle(BuildContext context) => TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: Theme.of(context).colorScheme.onSurface,
  );

  static TextStyle body(BuildContext context) => TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: Theme.of(context).colorScheme.onSurface,
    height: 1.45,
  );

  static TextStyle secondary(BuildContext context) => TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static TextStyle caption(BuildContext context) => TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
  );

  static TextStyle digitalId(BuildContext context) => TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.8,
    color: Theme.of(context).colorScheme.onSurface,
  );

  static TextStyle button(BuildContext context) => TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: Theme.of(context).colorScheme.onPrimary,
  );
}

/// Full Material 3 theme with PMDAP brand — light and dark.
class AppTheme {
  AppTheme._();

  static ThemeData light() {
    final scheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primaryNavy,
      onPrimary: Colors.white,
      primaryContainer: AppColors.lightBlue,
      onPrimaryContainer: AppColors.primaryNavy,
      secondary: AppColors.brandTeal,
      onSecondary: Colors.white,
      secondaryContainer: AppColors.paleTeal,
      onSecondaryContainer: AppColors.brandTeal,
      tertiary: AppColors.brandCyan,
      onTertiary: Colors.white,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      onSurfaceVariant: AppColors.textSecondary,
      surfaceContainerLow: AppColors.pageBg,
      surfaceContainerHighest: AppColors.divider,
      error: AppColors.error,
      onError: Colors.white,
      errorContainer: AppColors.errorBg,
      onErrorContainer: AppColors.error,
      outline: AppColors.border,
      outlineVariant: AppColors.divider,
      shadow: Colors.black.withAlpha(18),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.pageBg,
      visualDensity: VisualDensity.standard,

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.lightBlue,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: AppColors.primaryNavy);
          }
          return IconThemeData(color: AppColors.textMuted);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryNavy,
            );
          }
          return TextStyle(fontSize: 12, color: AppColors.textMuted);
        }),
        height: 64,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.input),
          borderSide: const BorderSide(color: Color(0xFFDCE3EA)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.input),
          borderSide: const BorderSide(color: Color(0xFFDCE3EA)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.input),
          borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.input),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        errorStyle: TextStyle(color: AppColors.error, fontSize: 12),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primaryNavy,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.button),
          ),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.button),
          ),
          side: const BorderSide(color: AppColors.primaryBlue),
          foregroundColor: AppColors.primaryBlue,
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(48, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          foregroundColor: AppColors.primaryBlue,
        ),
      ),

      cardTheme: CardThemeData(
        elevation: 1,
        shadowColor: Colors.black.withAlpha(14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.card),
          side: const BorderSide(color: AppColors.border),
        ),
        color: AppColors.surface,
      ),

      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.badge),
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.card),
        ),
      ),

      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.card),
        ),
      ),

      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.primaryNavy,
        unselectedLabelColor: AppColors.textMuted,
        indicatorColor: AppColors.primaryNavy,
      ),
    );
  }

  static ThemeData dark() {
    final scheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.darkPrimaryBlue,
      onPrimary: AppColors.darkBg,
      primaryContainer: AppColors.darkElevated,
      onPrimaryContainer: AppColors.darkPrimaryBlue,
      secondary: AppColors.darkTeal,
      onSecondary: AppColors.darkBg,
      secondaryContainer: AppColors.darkElevated,
      onSecondaryContainer: AppColors.darkTeal,
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkTextPrimary,
      onSurfaceVariant: AppColors.darkTextSecondary,
      surfaceContainerLow: AppColors.darkBg,
      surfaceContainerHighest: AppColors.darkElevated,
      error: AppColors.darkError,
      onError: AppColors.darkBg,
      errorContainer: AppColors.errorBg.withAlpha(30),
      onErrorContainer: AppColors.darkError,
      outline: AppColors.darkBorder,
      outlineVariant: AppColors.darkElevated,
      shadow: Colors.black.withAlpha(30),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.darkBg,
      visualDensity: VisualDensity.standard,

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        foregroundColor: AppColors.darkTextPrimary,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.darkTextPrimary,
        ),
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.darkSurface,
        indicatorColor: AppColors.darkElevated,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: AppColors.darkPrimaryBlue);
          }
          return IconThemeData(color: AppColors.darkTextSecondary);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.darkPrimaryBlue,
            );
          }
          return TextStyle(fontSize: 12, color: AppColors.darkTextSecondary);
        }),
        height: 64,
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.darkPrimaryBlue,
        foregroundColor: AppColors.darkBg,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkElevated,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.input),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.input),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.input),
          borderSide: const BorderSide(
            color: AppColors.darkPrimaryBlue,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.input),
          borderSide: const BorderSide(color: AppColors.darkError),
        ),
        errorStyle: TextStyle(color: AppColors.darkError, fontSize: 12),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.button),
          ),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.button),
          ),
          side: const BorderSide(color: AppColors.darkPrimaryBlue),
          foregroundColor: AppColors.darkPrimaryBlue,
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(48, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          foregroundColor: AppColors.darkPrimaryBlue,
        ),
      ),

      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.card),
          side: const BorderSide(color: AppColors.darkBorder),
        ),
        color: AppColors.darkSurface,
      ),

      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.badge),
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.card),
        ),
      ),

      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.card),
        ),
      ),
    );
  }
}
