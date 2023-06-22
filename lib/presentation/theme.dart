import 'package:flutter/material.dart';

ThemeData tsOneThemeData = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
  primaryColor: const Color(0xFFE32526),
  backgroundColor: tsOneColorScheme.background,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  useMaterial3: true,
);

ColorScheme tsOneColorScheme = const ColorScheme(
  primary: Color(0xFFE32526),
  primaryVariant: Color(0xFFBB1F1F),
  secondary: Color(0xFFFFFFFF),
  secondaryVariant: Color(0xFFEAEAEA),
  surface: Color(0xFFF5F5F5), // for card background
  background: Color(0xFFFDFDFD), // for page background
  error: Color(0xFFE32526),
  onPrimary: Color(0xFFFFFFFF),
  onSecondary: Color(0xFF000000),
  onSurface: Color(0xFF000000),
  onBackground: Color(0xFF000000),
  onError: Color(0xFFFFFFFF),
  brightness: Brightness.light,
);