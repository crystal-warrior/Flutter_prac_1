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
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
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
  );

}