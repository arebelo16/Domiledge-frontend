import 'package:flutter/material.dart';

class ThemeMapper {
  static ThemeMode toMode(String api) {
    switch (api) {
      case 'dark': return ThemeMode.dark;
      case 'system': return ThemeMode.system;
      default: return ThemeMode.light;
    }
  }

  static String toApi(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.dark: return 'dark';
      case ThemeMode.system: return 'system';
      case ThemeMode.light:
      return 'light';
    }
  }
}
