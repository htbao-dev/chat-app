import 'package:flutter/material.dart';

const _kBackgroundColor = Color(0xFF323a4d);
const _kPrimaryColor = Colors.amber;

const kIconTheme = IconThemeData(color: Colors.white);

const kInputDecorationTheme = InputDecorationTheme(
  labelStyle: TextStyle(color: Colors.white),
  enabledBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.white),
  ),
);

var kDarkTheme = ThemeData(
  fontFamily: 'Lexend',
  brightness: Brightness.dark,
  backgroundColor: _kBackgroundColor,
  scaffoldBackgroundColor: const Color(0xff1e232e), //dark background
  primaryColor: _kPrimaryColor,
  // listTileTheme: ,
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
    primary: _kPrimaryColor,
  )),
  buttonTheme: ButtonThemeData(
    buttonColor: _kPrimaryColor,
    textTheme: ButtonTextTheme.primary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
  ),
  listTileTheme: const ListTileThemeData(
      selectedColor: Colors.white,
      selectedTileColor: Colors.white,
      textColor: _kPrimaryColor,
      iconColor: Colors.amber),
  colorScheme: const ColorScheme.dark(
    primary: _kPrimaryColor,
  ),
  appBarTheme: const AppBarTheme(
    color: _kBackgroundColor,
    elevation: 0,
  ),

  // inputDecorationTheme: kInputDecorationTheme,
  // textTheme: TextTheme()
);

const kScaffoldPadding = EdgeInsets.all(20);
const kScreenPadding = EdgeInsets.symmetric(horizontal: 20, vertical: 20);
