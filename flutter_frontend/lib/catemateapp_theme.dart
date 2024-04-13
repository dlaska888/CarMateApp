import 'package:flutter/material.dart';

Color primary = const Color(0xFF0090BE);
ThemeData lightTheme = ThemeData(
    colorScheme: ThemeData().colorScheme.copyWith(primary: primary),
    primaryColor: primary,
    primaryColorDark: const Color(0xFF002278),
    primaryColorLight: const Color.fromARGB(255, 114, 189, 214),
    disabledColor: const Color.fromRGBO(169, 169, 169, 0.36),
    scaffoldBackgroundColor: Colors.white,
    cardColor: Colors.white,
    dividerColor: const Color(0x000ffeee),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 48.0, vertical: 24.0),
        backgroundColor: Colors.white,
        foregroundColor: primary, // Set foreground color to primaryColor
        textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    ),
    textTheme: TextTheme(
        displayLarge: TextStyle(
      color: Colors.white,
      fontSize: 48.0,
      fontWeight: FontWeight.bold,
      shadows: [
        Shadow(
          color: Colors.black.withOpacity(0.25), // Shadow color
          blurRadius: 4.0, // Adjusts shadow blur (optional)
          offset: const Offset(0.0, 4.0), // Offset of the shadow (X, Y)
        ),
      ],
    )),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      fillColor: Colors.white, // Set background color to white
      filled: true, // Apply the filled background
      contentPadding: EdgeInsets.all(8.0), // Adjust padding if needed
      constraints: BoxConstraints(maxWidth: 500),
    ));
