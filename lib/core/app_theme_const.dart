import 'package:flutter/material.dart';
import 'package:golden_thailand/core/size_const.dart';
import 'package:google_fonts/google_fonts.dart';

const Color primaryColor = Color(0xFF3572ef);

const Map<int, Color> colorShades = {
  50: Color(0xFFFFF0F0),
  100: Color(0xFFFFD0D0),
  200: Color(0xFFFFB0B0),
  300: Color(0xFFFF9090),
  400: Color(0xFFFF7070),
  500: primaryColor, // Main color
  600: primaryColor,
  700: primaryColor,
  800: primaryColor,
  900: primaryColor,
  // 600: Color(0xFFE14040),
  // 700: Color(0xFFD03030),
  // 800: Color(0xFFC02020),
  // 900: Color(0xFFB01010),
};

const MaterialColor primarySwatch = MaterialColor(0xFF3572ef, colorShades);

// const MaterialColor primarySwatch = MaterialColor(
//   0xFFF15757,
//   _primaryColorSwatch,
// );

ThemeData myTheme = ThemeData(
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,

    iconTheme: IconThemeData(color: SScolor.primaryColor),

    // foregroundColor: SScolor.primaryColor,
    toolbarTextStyle: TextStyle(
      fontSize: FontSize.normal,
      fontWeight: FontWeight.normal,
      fontFamily: GoogleFonts.notoSansThai().fontFamily,
    ),
    titleTextStyle: TextStyle(
      fontWeight: FontWeight.bold,
      fontFamily: GoogleFonts.notoSansThai().fontFamily,
      color: SScolor.primaryColor,
      fontSize: FontSize.normal + 6,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          backgroundColor: SScolor.primaryColor,
          foregroundColor: SScolor.whiteColor)),
  primarySwatch: primarySwatch,
  useMaterial3: false,
  fontFamily: GoogleFonts.notoSansThai().fontFamily,
  primaryColor: SScolor.primaryColor,
  scaffoldBackgroundColor: SScolor.homeBackgroundGrey,
  // colorScheme: ColorScheme.light(primary: primaryColor,onPrimary: primaryColor),
  iconTheme: IconThemeData(color: SScolor.primaryColor),
  dialogTheme: DialogTheme(backgroundColor: Colors.white),
  floatingActionButtonTheme: FloatingActionButtonThemeData(elevation: 0),
  tabBarTheme: TabBarTheme(
      unselectedLabelColor: SScolor.greyColor,
      labelStyle: TextStyle(fontSize: FontSize.normal + 2),
      labelColor: SScolor.primaryColor,
      indicatorColor: SScolor.primaryColor),
  popupMenuTheme: PopupMenuThemeData(
    color: Colors.white,
  ),
);

abstract class SScolor {
  static Color primaryColor = Color(0xFF3572ef);
  static Color secondaryColor = Color(0xFF3572ef);
  static Color textColor = Color(0xFF212121);
  static Color buttonBG = Color(0xFFEFFFEC);
  static Color contrast = Color(0xFF9E9E9E);
  static Color whiteColor = Color(0xFFFEFFFE);
  static Color borderStoke = Color(0xFFD6D6D6);
  static Color backgroundColor = Color(0xFFF8F9FD);
  static Color disable = Color(0xFFDBDBDB);
  static Color tooglebg = Color(0xFFACDCA2);
  static Color greyColor = Color(0xFFA7A7A7);
  static Color homeBackgroundGrey = Color(0xFFF0F0F0);
  static Color discountColor = Color(0xFF5BBA47);
  static Color badgeColor = Color(0x335BBA47);
}
