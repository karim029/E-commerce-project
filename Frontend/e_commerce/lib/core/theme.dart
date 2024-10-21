import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Defines the application's theme data.
final ThemeData lightAppTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 237, 237, 237),
    brightness: Brightness.light,
  ),
  inputDecorationTheme: InputDecorationTheme(
    // Style for the prefix (e.g., $ sign) and suffix (e.g., USD) in input fields
    prefixStyle: const TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
    ),
    suffixStyle: const TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
    ),
    // Style for input labels and hints
    labelStyle: GoogleFonts.poppins(
      color: Colors.black,
      fontWeight: FontWeight.bold,
    ),
    hintStyle: GoogleFonts.poppins(
      color: const Color.fromARGB(170, 210, 210, 210),
      fontWeight: FontWeight.w200,
    ),
    // Styling for borders of input fields
    focusedBorder: const UnderlineInputBorder(
      borderSide: BorderSide(
        style: BorderStyle.solid,
        width: 2,
        color: Colors.black,
      ),
    ),
    border: const UnderlineInputBorder(
      borderSide: BorderSide(
        style: BorderStyle.solid,
        width: 2,
        color: Colors.black,
      ),
    ),
    contentPadding: EdgeInsets.zero,
  ),
  textTheme: GoogleFonts.poppinsTextTheme().copyWith(
    bodyMedium: const TextStyle().copyWith(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    ),
    labelMedium: const TextStyle().copyWith(
      color: Colors.black,
      fontSize: 18,
      fontWeight: FontWeight.w400,
    ),
    labelLarge: const TextStyle().copyWith(
      fontWeight: FontWeight.bold,
      fontSize: 34,
    ),
  ),
  listTileTheme: ListTileThemeData(
    subtitleTextStyle: GoogleFonts.poppins().copyWith(
      fontSize: 16,
      color: Colors.grey,
      fontWeight: FontWeight.w400,
    ),
    tileColor: Colors.grey[200],
    contentPadding: const EdgeInsets.all(6.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(22.0),
    ),
  ),
  cardTheme: CardTheme(
    elevation: 0,
    shadowColor: Colors.white,
    color: Colors.blue,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(22.0),
    ),
  ),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    titleTextStyle: GoogleFonts.poppins(
      fontSize: 24,
      color: Colors.black,
      fontWeight: FontWeight.bold,
    ),
    backgroundColor: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: const ButtonStyle().copyWith(
      textStyle: WidgetStatePropertyAll(
        GoogleFonts.poppins().copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: const ButtonStyle().copyWith(
      textStyle: WidgetStatePropertyAll(
        GoogleFonts.poppins().copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ),
);

final ThemeData darkAppTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF1E1E1E),
    brightness: Brightness.dark,
  ),
  inputDecorationTheme: InputDecorationTheme(
    prefixStyle: const TextStyle(
      color: Color(0xFFB3B3B3),
      fontWeight: FontWeight.bold,
    ),
    suffixStyle: const TextStyle(
      color: Color(0xFFB3B3B3),
      fontWeight: FontWeight.bold,
    ),
    labelStyle: GoogleFonts.poppins(
      color: const Color(0xFFB3B3B3),
      fontWeight: FontWeight.bold,
    ),
    hintStyle: GoogleFonts.poppins(
      color: const Color(0xFF6C6C6C),
      fontWeight: FontWeight.w200,
    ),
    focusedBorder: const UnderlineInputBorder(
      borderSide: BorderSide(
        style: BorderStyle.solid,
        width: 2,
      ),
    ),
    border: const UnderlineInputBorder(
      borderSide: BorderSide(
        style: BorderStyle.solid,
        width: 2,
        color: Color(0xFFB3B3B3),
      ),
    ),
    contentPadding: EdgeInsets.zero,
  ),
  textTheme: GoogleFonts.poppinsTextTheme().copyWith(
    bodyLarge: const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 18,
      color: Colors.white,
    ),
    bodyMedium: const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: Colors.white,
    ),
    labelMedium: const TextStyle(
      color: Color(0xFFB3B3B3),
      fontSize: 18,
      fontWeight: FontWeight.w400,
    ),
    labelLarge: const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 34,
      color: Colors.white,
    ),
  ),
  listTileTheme: ListTileThemeData(
    subtitleTextStyle: GoogleFonts.poppins().copyWith(
      fontSize: 16,
      color: const Color(0xFFB3B3B3),
      fontWeight: FontWeight.w400,
    ),
    tileColor: const Color(0xFF333333),
    contentPadding: const EdgeInsets.all(6.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(22.0),
    ),
  ),
  cardTheme: CardTheme(
    elevation: 0,
    shadowColor: Colors.black,
    color: const Color(0xFF424242),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(22.0),
    ),
  ),
  scaffoldBackgroundColor: const Color(0xFF121212),
  appBarTheme: AppBarTheme(
    titleTextStyle: GoogleFonts.poppins(
      fontSize: 24,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
    backgroundColor: const Color(0xFF1E1E1E),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: const ButtonStyle().copyWith(
      textStyle: WidgetStatePropertyAll(
        GoogleFonts.poppins().copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: const ButtonStyle().copyWith(
      textStyle: WidgetStatePropertyAll(
        GoogleFonts.poppins().copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ),
  ),
  drawerTheme: DrawerThemeData(
    backgroundColor: const Color(0xFF1E1E1E),
    scrimColor: Colors.black.withOpacity(0.5),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
    ),
  ),
);
