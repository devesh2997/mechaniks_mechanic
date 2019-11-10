import 'package:flutter/material.dart';

String monthIntToString(int m) {
  switch (m) {
    case 1:
      return 'January';
    case 2:
      return 'February';
    case 3:
      return 'March';
    case 4:
      return 'April';
    case 5:
      return 'May';
    case 6:
      return 'June';
    case 7:
      return 'July';
    case 8:
      return 'August';
    case 9:
      return 'September';
    case 10:
      return 'October';
    case 11:
      return 'November';
    case 12:
      return 'December';
    default:
      return '';
  }
}

String toDateString(DateTime date) {
  String d = "";
  d += date.day.toString() +
      ' ' +
      monthIntToString(date.month) +
      ' ' +
      date.year.toString();
  return d;
}

int _getColorFromHex(String hexColor) {
  hexColor = hexColor.toUpperCase().replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF" + hexColor;
  }
  return int.parse(hexColor, radix: 16);
}

String beautifyString(String str) {
  if (str.length == 0) return str;
  if (str.length == 1) return str[0].toUpperCase();
  return str[0].toUpperCase() + str.substring(1);
}

String beautifyName(String str){
  List<String> n = str.split(' ');
  for(int i=0;i<n.length;i++){
    n[i] = n[i][0].toUpperCase() + n[i].substring(1);
  }
  String nn = "";
  for(int i=0;i<n.length;i++){
    nn+=n[i]+' ';
  }
  return nn;
}

String getRupee() {
  return '\u20B9';
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

MaterialColor hexToMaterialColor(final String hexColor) {
  Map<int, Color> color = {
    50: HexColor(hexColor).withOpacity(0.1),
    100: HexColor(hexColor).withOpacity(0.2),
    200: HexColor(hexColor).withOpacity(0.3),
    300: HexColor(hexColor).withOpacity(0.4),
    400: HexColor(hexColor).withOpacity(0.5),
    500: HexColor(hexColor).withOpacity(0.6),
    600: HexColor(hexColor).withOpacity(0.7),
    700: HexColor(hexColor).withOpacity(0.8),
    800: HexColor(hexColor).withOpacity(0.9),
    900: HexColor(hexColor).withOpacity(1),
  };

  return MaterialColor(_getColorFromHex(hexColor), color);
}

MaterialColor getPrimaryColor() {
  return hexToMaterialColor('#0DAC8E');
}

MaterialColor getAccentColor() {
  return hexToMaterialColor('#2952FF');
}

// MaterialColor getAccentColor() {
//   return hexToMaterialColor('#5AE6FF');
// }
