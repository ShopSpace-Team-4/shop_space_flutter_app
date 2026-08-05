import 'package:flutter/material.dart';

@immutable
abstract final class AppElevation {
  static const List<BoxShadow> none = [];

  static const List<BoxShadow> low = [
    BoxShadow(
      color: Color(0x0F000000),
      offset: Offset(0, 1),
      blurRadius: 4,
    ),
  ];

  static const List<BoxShadow> medium = [
    BoxShadow(
      color: Color(0x140F172A),
      offset: Offset(0, 2),
      blurRadius: 12,
    ),
  ];

  static const List<BoxShadow> high = [
    BoxShadow(
      color: Color(0x662563EB),
      offset: Offset(0, 4),
      blurRadius: 16,
    ),
  ];

  static const List<BoxShadow> button = [
    BoxShadow(
      color: Color(0x592563EB),
      offset: Offset(0, 3),
      blurRadius: 10,
    ),
  ];
}
