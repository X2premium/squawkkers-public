import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const double _radius = 18;
  static const Color _seed = Color(0xFF0B6E6B);
  static const Color _lightBg = Color(0xFFF6F4F0);
  static const Color _darkBg = Color(0xFF0C0F12);

  static ThemeData applyBase(ThemeData base, {required bool trueBlack}) {
    var scheme = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: base.brightness,
      background: base.brightness == Brightness.dark ? _darkBg : _lightBg,
    );

    if (base.brightness == Brightness.dark && trueBlack) {
      scheme = scheme.copyWith(
        surface: Colors.black,
        background: Colors.black,
        surfaceContainerLowest: const Color(0xFF0B0B0B),
        surfaceContainerLow: const Color(0xFF101010),
        surfaceContainer: const Color(0xFF141414),
        surfaceContainerHigh: const Color(0xFF181818),
        surfaceContainerHighest: const Color(0xFF1C1C1C),
      );
    }
    final textTheme = GoogleFonts.interTightTextTheme(base.textTheme).copyWith(
      displaySmall: GoogleFonts.spaceGrotesk(
          fontSize: 36, fontWeight: FontWeight.w700, letterSpacing: -0.6, color: scheme.onSurface),
      headlineSmall: GoogleFonts.spaceGrotesk(
          fontSize: 24, fontWeight: FontWeight.w700, letterSpacing: -0.4, color: scheme.onSurface),
      titleLarge: GoogleFonts.spaceGrotesk(fontSize: 20, fontWeight: FontWeight.w600, color: scheme.onSurface),
      titleMedium: GoogleFonts.spaceGrotesk(fontSize: 16, fontWeight: FontWeight.w600, color: scheme.onSurface),
      bodyLarge: GoogleFonts.interTight(
          fontSize: 16, fontWeight: FontWeight.w400, height: 1.35, color: scheme.onSurface),
      bodyMedium: GoogleFonts.interTight(
          fontSize: 14, fontWeight: FontWeight.w400, height: 1.35, color: scheme.onSurface),
      bodySmall: GoogleFonts.interTight(
          fontSize: 12, fontWeight: FontWeight.w400, height: 1.3, color: scheme.onSurfaceVariant),
      labelLarge: GoogleFonts.spaceGrotesk(fontSize: 14, fontWeight: FontWeight.w600, color: scheme.onSurface),
      labelMedium: GoogleFonts.spaceGrotesk(fontSize: 12, fontWeight: FontWeight.w600, color: scheme.onSurface),
    );

    final outline = scheme.outlineVariant.withOpacity(base.brightness == Brightness.dark ? 0.5 : 0.7);
    final cardColor = scheme.surfaceContainerLow;
    final elevated = scheme.surfaceContainerHigh;

    return base.copyWith(
      colorScheme: scheme,
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      scaffoldBackgroundColor: scheme.background,
      canvasColor: scheme.background,
      dividerTheme: DividerThemeData(
        color: outline,
        space: 24,
        thickness: 1,
      ),
      cardTheme: CardThemeData(
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
        textColor: scheme.onSurface,
        titleTextStyle: textTheme.bodyLarge?.copyWith(color: scheme.onSurface),
        subtitleTextStyle: textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
      ),
      iconTheme: IconThemeData(color: scheme.onSurfaceVariant),
      primaryIconTheme: IconThemeData(color: scheme.onSurfaceVariant),
      hintColor: scheme.onSurfaceVariant,
      disabledColor: scheme.onSurfaceVariant.withOpacity(0.6),
      unselectedWidgetColor: scheme.onSurfaceVariant,
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: scheme.background,
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
        backgroundColor: elevated,
        surfaceTintColor: Colors.transparent,
      ),
      chipTheme: base.chipTheme.copyWith(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        side: BorderSide(color: outline),
        labelStyle: textTheme.labelMedium?.copyWith(color: scheme.onSurface),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHighest,
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
      dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: textTheme.bodyMedium?.copyWith(color: scheme.onSurface),
        menuStyle: MenuStyle(
          backgroundColor: MaterialStatePropertyAll(scheme.surfaceContainerHigh),
          surfaceTintColor: const MaterialStatePropertyAll(Colors.transparent),
        ),
      ),
      menuTheme: MenuThemeData(
        style: MenuStyle(
          backgroundColor: MaterialStatePropertyAll(scheme.surfaceContainerHigh),
          surfaceTintColor: const MaterialStatePropertyAll(Colors.transparent),
          foregroundColor: MaterialStatePropertyAll(scheme.onSurface),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: elevated,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: scheme.onSurface),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: elevated,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(_radius)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: elevated,
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
      useMaterial3: true,
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
    final scheme = Theme.of(context).colorScheme;
    return Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: Theme.of(context).brightness == Brightness.dark
                    ? [
                        trueBlack ? Colors.black : _darkBg,
                        scheme.primary.withOpacity(0.08),
                        _darkBg,
                      ]
                    : [
                        _lightBg,
                        scheme.primary.withOpacity(0.08),
                        _lightBg,
                      ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
        ),
        Positioned(
          right: -80,
          top: -60,
          child: Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: scheme.primary.withOpacity(0.08),
            ),
          ),
        ),
        Positioned(
          left: -60,
          bottom: -40,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: scheme.tertiary.withOpacity(0.08),
            ),
          ),
        ),
        child,
      ],
    );
  }
}
