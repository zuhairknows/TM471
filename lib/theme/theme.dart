import 'package:flutter/material.dart';

const colorPrimary = Color(0xFFa55555);

final theme = ThemeData(
  colorScheme: const ColorScheme.light(
    primary: colorPrimary,
    secondary: colorPrimary,
  ),
  elevatedButtonTheme: elevatedButtonTheme,
  outlinedButtonTheme: outlinedButtonTheme,
  inputDecorationTheme: inputDecorationTheme,
  cardTheme: cardTheme,
);

final cardTheme = CardTheme(
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
);

final elevatedButtonTheme = ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    minimumSize: const Size.fromHeight(48),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  ),
);

final outlinedButtonTheme = OutlinedButtonThemeData(
  style: OutlinedButton.styleFrom(
    minimumSize: const Size.fromHeight(48),
    side: const BorderSide(
      width: 2,
      color: colorPrimary,
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  ),
);

final inputDecorationTheme = InputDecorationTheme(
  border: OutlineInputBorder(
    borderSide: const BorderSide(width: 2, color: colorPrimary),
    borderRadius: BorderRadius.circular(8),
  ),
  disabledBorder: OutlineInputBorder(
    borderSide: BorderSide(width: 1, color: Colors.black.withAlpha(0x66)),
    borderRadius: BorderRadius.circular(8),
  ),
);
