import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(

    scaffoldBackgroundColor: Colors.white,

    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Colors.lightGreen, //
      selectionColor: Colors.lightGreen.withOpacity(0.3), // цвет выделения
      selectionHandleColor: Colors.lightGreen, // цвет ручек выделения
    ),



    primarySwatch: Colors.lightGreen,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.lightGreen,
      primary: Colors.lightGreen,
    ),
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.lightGreen,
      foregroundColor: Colors.white,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.lightGreen,
      foregroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.lightGreen,
        foregroundColor: Colors.white,
      ),

    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: Colors.amber,
      inactiveTrackColor: Colors.amber[100],
      thumbColor: Colors.amber,
      overlayColor: Colors.amber[100]!.withOpacity(0.3),
      valueIndicatorColor: Colors.amber,
      activeTickMarkColor: Colors.amber,
      inactiveTickMarkColor: Colors.amber[100],
      trackHeight: 4,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
      valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
      showValueIndicator: ShowValueIndicator.always,
    ),

    inputDecorationTheme: InputDecorationTheme(


      border: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.lightGreen),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.lightGreen),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.lightGreen, width: 2),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      labelStyle: const TextStyle(color: Colors.lightGreen),
      floatingLabelStyle: const TextStyle(color: Colors.lightGreen),
      hintStyle: const TextStyle(color: Colors.grey),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),



    ),

    datePickerTheme: DatePickerThemeData(
      backgroundColor: Colors.white,
      headerBackgroundColor: Colors.lightGreen,
      headerForegroundColor: Colors.white,
      dayStyle: const TextStyle(color: Colors.black87),
      todayForegroundColor: WidgetStateProperty.all(Colors.lightGreen),
      todayBackgroundColor: WidgetStateProperty.all(Colors.lightGreen.withValues(alpha: 0.2)),
      rangeSelectionBackgroundColor: Colors.lightGreen.withValues(alpha: 0.3),
      rangeSelectionOverlayColor: WidgetStateProperty.all(Colors.lightGreen.withValues(alpha: 0.2)),
      todayBorder: const BorderSide(color: Colors.lightGreen, width: 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );

  // Темная тема "Ночной сад"
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: const Color(0xFF1A1A2E), // Темно-серый фон
    
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: const Color(0xFF9BB5FF), // Нежно-голубоватый
      selectionColor: const Color(0xFF9BB5FF).withOpacity(0.3),
      selectionHandleColor: const Color(0xFF9BB5FF),
    ),

    primarySwatch: Colors.blue,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF6C5CE7), // Фиолетовый
      primary: const Color(0xFF6C5CE7),
      secondary: const Color(0xFF9BB5FF), // Нежно-голубоватый
      surface: const Color(0xFF2D2D44), // Темно-серый для карточек
      background: const Color(0xFF1A1A2E),
      brightness: Brightness.dark,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: const Color(0xFFE0E0E0), // Светло-серый для текста на темном фоне
      onBackground: const Color(0xFFE0E0E0),
    ),
    useMaterial3: true,
    
    // Настройка текста для темной темы
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: Color(0xFFE0E0E0)),
      displayMedium: TextStyle(color: Color(0xFFE0E0E0)),
      displaySmall: TextStyle(color: Color(0xFFE0E0E0)),
      headlineLarge: TextStyle(color: Color(0xFFE0E0E0)),
      headlineMedium: TextStyle(color: Color(0xFFE0E0E0)),
      headlineSmall: TextStyle(color: Color(0xFFE0E0E0)),
      titleLarge: TextStyle(color: Color(0xFFE0E0E0)),
      titleMedium: TextStyle(color: Color(0xFFE0E0E0)),
      titleSmall: TextStyle(color: Color(0xFFE0E0E0)),
      bodyLarge: TextStyle(color: Color(0xFFE0E0E0)),
      bodyMedium: TextStyle(color: Color(0xFFE0E0E0)),
      bodySmall: TextStyle(color: Color(0xFFB0B0B0)),
      labelLarge: TextStyle(color: Color(0xFFE0E0E0)),
      labelMedium: TextStyle(color: Color(0xFFE0E0E0)),
      labelSmall: TextStyle(color: Color(0xFFB0B0B0)),
    ),
    
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF2D2D44), // Темно-серый
      foregroundColor: Color(0xFF9BB5FF), // Нежно-голубоватый текст
      titleTextStyle: TextStyle(
        color: Color(0xFF9BB5FF),
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF6C5CE7), // Фиолетовый
      foregroundColor: Colors.white,
    ),
    
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF6C5CE7), // Фиолетовый
        foregroundColor: Colors.white,
      ),
    ),
    
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFF9BB5FF), // Нежно-голубоватый
      ),
    ),
    
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF9BB5FF), // Нежно-голубоватый
        side: const BorderSide(color: Color(0xFF6C5CE7)), // Фиолетовая граница
      ),
    ),
    
    sliderTheme: SliderThemeData(
      activeTrackColor: const Color(0xFF9BB5FF), // Нежно-голубоватый
      inactiveTrackColor: const Color(0xFF9BB5FF).withOpacity(0.3),
      thumbColor: const Color(0xFF9BB5FF),
      overlayColor: const Color(0xFF9BB5FF).withOpacity(0.3),
      valueIndicatorColor: const Color(0xFF6C5CE7),
      activeTickMarkColor: const Color(0xFF9BB5FF),
      inactiveTickMarkColor: const Color(0xFF9BB5FF).withOpacity(0.3),
      trackHeight: 4,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
      valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
      showValueIndicator: ShowValueIndicator.always,
    ),

    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFF6C5CE7)),
        borderRadius: BorderRadius.circular(8),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFF6C5CE7)),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFF9BB5FF), width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      labelStyle: const TextStyle(color: Color(0xFF9BB5FF)),
      floatingLabelStyle: const TextStyle(color: Color(0xFF9BB5FF)),
      hintStyle: TextStyle(color: Colors.grey[400]),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      fillColor: const Color(0xFF2D2D44),
      filled: true,
    ),

    cardTheme: CardThemeData(
      color: const Color(0xFF2D2D44), // Темно-серый для карточек
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    
    dividerTheme: const DividerThemeData(
      color: Color(0xFF3D3D5C), // Темно-серый для разделителей
      thickness: 1,
    ),
    
    listTileTheme: const ListTileThemeData(
      textColor: Color(0xFFE0E0E0), // Светло-серый для текста
      iconColor: Color(0xFF9BB5FF), // Нежно-голубоватый для иконок
    ),

    datePickerTheme: DatePickerThemeData(
      backgroundColor: const Color(0xFF2D2D44),
      headerBackgroundColor: const Color(0xFF6C5CE7),
      headerForegroundColor: Colors.white,
      dayStyle: const TextStyle(color: Color(0xFF9BB5FF)),
      todayForegroundColor: WidgetStateProperty.all(const Color(0xFF9BB5FF)),
      todayBackgroundColor: WidgetStateProperty.all(const Color(0xFF6C5CE7).withOpacity(0.3)),
      rangeSelectionBackgroundColor: const Color(0xFF6C5CE7).withOpacity(0.3),
      rangeSelectionOverlayColor: WidgetStateProperty.all(const Color(0xFF6C5CE7).withOpacity(0.2)),
      todayBorder: const BorderSide(color: Color(0xFF9BB5FF), width: 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}
