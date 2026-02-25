import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const double _radius = 18;

  static ThemeData applyBase(ThemeData base, {required bool trueBlack}) {
    final scheme = base.colorScheme;
    final textTheme = GoogleFonts.manropeTextTheme(base.textTheme).copyWith(
      displaySmall: GoogleFonts.manrope(fontSize: 36, fontWeight: FontWeight.w700, letterSpacing: -0.5),
      headlineSmall: GoogleFonts.manrope(fontSize: 24, fontWeight: FontWeight.w700, letterSpacing: -0.3),
      titleLarge: GoogleFonts.manrope(fontSize: 20, fontWeight: FontWeight.w600),
      titleMedium: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.w600),
      bodyLarge: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.w400, height: 1.3),
      bodyMedium: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w400, height: 1.3),
      labelLarge: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w600),
    );

    final outline = scheme.outlineVariant.withOpacity(base.brightness == Brightness.dark ? 0.55 : 0.6);
    final cardColor = scheme.surface;

    return base.copyWith(
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      scaffoldBackgroundColor: Colors.transparent,
      canvasColor: Colors.transparent,
      dividerTheme: DividerThemeData(
        color: outline,
        space: 24,
        thickness: 1,
      ),
      cardTheme: CardTheme(
        color: cardColor,
        elevation: 0,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radius),
          side: BorderSide(color: outline),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        iconColor: scheme.onSurfaceVariant,
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        foregroundColor: scheme.onSurface,
        titleTextStyle: textTheme.titleLarge?.copyWith(color: scheme.onSurface),
        iconTheme: IconThemeData(color: scheme.onSurfaceVariant),
      ),
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        indicatorColor: scheme.primary.withOpacity(0.12),
        labelTextStyle: MaterialStateProperty.resolveWith(
          (states) => textTheme.labelMedium?.copyWith(
            color: states.contains(MaterialState.selected) ? scheme.onSurface : scheme.onSurfaceVariant,
            fontWeight: states.contains(MaterialState.selected) ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
        iconTheme: MaterialStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(MaterialState.selected) ? scheme.onSurface : scheme.onSurfaceVariant,
            size: 22,
          ),
        ),
        backgroundColor: scheme.surface.withOpacity(trueBlack ? 0.98 : 0.92),
        surfaceTintColor: Colors.transparent,
      ),
      chipTheme: base.chipTheme.copyWith(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        side: BorderSide(color: outline),
        labelStyle: textTheme.labelMedium?.copyWith(color: scheme.onSurface),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHighest.withOpacity(base.brightness == Brightness.dark ? 0.2 : 0.7),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.primary, width: 1.2),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.surfaceContainerHighest,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: scheme.onSurface),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(_radius)),
        ),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_radius)),
        titleTextStyle: textTheme.titleLarge?.copyWith(color: scheme.onSurface),
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.onSurface,
          textStyle: textTheme.labelLarge,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.onSurface,
          side: BorderSide(color: outline),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: textTheme.labelLarge,
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
      ),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      useMaterial3: true,
    );
  }

  static BoxDecoration backgroundDecoration(ThemeData theme, {required bool trueBlack}) {
    if (theme.brightness == Brightness.dark) {
      return BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: trueBlack
              ? const [Color(0xFF000000), Color(0xFF0B0C0E)]
              : const [Color(0xFF0F1216), Color(0xFF131922)],
        ),
      );
    }

    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFFF7F6F4),
          theme.colorScheme.primary.withOpacity(0.06),
          const Color(0xFFF0F3F6),
        ],
        stops: const [0.0, 0.5, 1.0],
      ),
    );
  }

  static Widget background({
    required BuildContext context,
    required bool trueBlack,
    required Widget? child,
  }) {
    if (child == null) {
      return const SizedBox.shrink();
    }
    return Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: backgroundDecoration(Theme.of(context), trueBlack: trueBlack),
          ),
        ),
        child,
      ],
    );
  }
}
