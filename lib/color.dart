import 'package:flutter/material.dart';

class MColor {
  static Color red = const Color(0xffFF1818);
  static Color blue = const Color(0xff5463FF);
  static Color grey = const Color.fromARGB(255, 143, 143, 143);
  static Color orange = const Color(0xFFFF7000);
  static Color block = const Color(0xFF1C315E);
  static Color done = const Color(0xFF86C8BC);
  static Map<String, Color> status = {
    "waiting": orange,
    "block": block,
    "done": done,
  };
}
