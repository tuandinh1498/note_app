import 'package:flutter/material.dart';

import 'colors.dart';

class Themings {
  static final ThemeData lighTheme=ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.blue,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.white,

        shape: RoundedRectangleBorder(side: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(45.0),

            )
        )

    ),
    iconTheme: IconThemeData(
      color: Colors.black
    ),
    appBarTheme: AppBarTheme(
      // toolbarTextStyle: lightText,
      backgroundColor: Colors.white,
        elevation: 2,
      titleTextStyle: displayLarge,
      iconTheme: const IconThemeData(
        color: Colors.black,

      )
    ),
    textTheme: const TextTheme(
      // bodyLarge: lightText,
      // bodyMedium: lightText,
      // labelMedium: lightText,
      // bodySmall: lightText,
      // labelLarge: lightText,
      // labelSmall: lightText,
      displayLarge: displayLarge,
      displayMedium:displayMedium
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red, // Button color
        foregroundColor: Colors.white, // Text color
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white, // Button color
          foregroundColor: Colors.black,
            side: BorderSide(color: Colors.black, width: 1),
          textStyle: TextStyle(
            color: Colors.black
          )// Text color
        )
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.green
    ),
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
        .copyWith(background: AppColors.whiteGrey),
  );
  static const TextStyle displayLarge = TextStyle(
      fontFamily: "Poppins",
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 22
  );

  static const TextStyle displayMedium = TextStyle(
      fontFamily: "Poppins",
      fontWeight: FontWeight.normal,
      fontSize: 16
  );

}
