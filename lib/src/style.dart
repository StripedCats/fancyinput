import 'package:flutter/material.dart';

enum IconShowCondition {
  always,
  focused,
}

class FancyInputStyle {
  final Color backgroundColor;
  final Color underlineColor;

  final bool includeDivider;
  final bool includeUnderline;

  final double topBorderRadius;
  final double bottomBorderRadius;

  final double dividerGap;
  final double suffixSize;

  final TextStyle prefixStyle;
  final TextStyle contentStyle;

  final EdgeInsets padding;

  const FancyInputStyle.android({
    this.dividerGap = 9.0,
    this.suffixSize = 14.0,

    this.prefixStyle = const TextStyle(
      color: Color(0xff868686),
      fontSize: 16,
      letterSpacing: 0.44
    ),
    this.contentStyle = const TextStyle(
      color: Color(0xff333333),
      fontSize: 16,
      letterSpacing: 0.44
    ),

    this.backgroundColor = const Color(0xffF0F0F0),
    this.underlineColor = const Color.fromRGBO(38, 50, 56, 0.38),
    this.includeDivider = true,

    this.topBorderRadius = 4.0,
    this.bottomBorderRadius = 0.0,
    this.padding = const EdgeInsets.all(16),

    this.includeUnderline = true,
  });

  const FancyInputStyle.iOS({
    this.includeUnderline = false,
    this.dividerGap = 12.0,
    this.suffixSize = 13.35,

    this.prefixStyle = const TextStyle(
      color: Color(0xff868686),
      fontSize: 24,
      letterSpacing: 0.44
    ),
    this.contentStyle = const TextStyle(
      color: Color(0xff333333),
      fontSize: 24,
      letterSpacing: 0.44
    ),

    this.backgroundColor = const Color(0xffF8F8F8),
    this.underlineColor = Colors.transparent,
    this.includeDivider = true,

    this.topBorderRadius = 18.0,
    this.bottomBorderRadius = 18.0,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 16, vertical: 12)
  });

  const FancyInputStyle({
    required this.topBorderRadius,
    required this.bottomBorderRadius,
    required this.dividerGap,

    required this.backgroundColor,
    required this.underlineColor,

    required this.includeDivider,

    required this.prefixStyle,
    required this.contentStyle,

    required this.padding,
    required this.suffixSize,

    required this.includeUnderline,
  });
}
