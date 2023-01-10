import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyThemes {
  static ThemeData lightTheme(BuildContext context) => ThemeData(
      primarySwatch: Colors.grey,
      //scaffoldBackgroundColor: LinearGradient(colors: gradientColor),
      fontFamily: GoogleFonts.asar().fontFamily,
      brightness: Brightness.light,
      appBarTheme: AppBarTheme(
        backgroundColor: barcolor,
        toolbarTextStyle: Theme.of(context).textTheme.bodyText2,
        titleTextStyle: Theme.of(context).textTheme.headline6,
      ));

  static ThemeData darkTheme(BuildContext context) => ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.grey,
      appBarTheme: AppBarTheme(
        backgroundColor: barcolorDark,
        toolbarTextStyle: Theme.of(context).textTheme.bodyText2,
        titleTextStyle: Theme.of(context).textTheme.headline6,
      ));

  static Color barcolor = (const Color(0xffB6E2D3));
  static Color barcolorDark = (Color.fromARGB(255, 99, 148, 145));
  static Color cardColor = const Color(0xffFAE8E0);
  static Color cardColorDark = (Color.fromARGB(255, 212, 158, 122));
  static Color backgroundColor = Color.fromARGB(255, 236, 144, 158);
  static Color backgroundColorDark = (Color.fromARGB(255, 171, 89, 98));
}
