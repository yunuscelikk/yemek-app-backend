import 'package:flutter/material.dart';

class Responsive {
  final BuildContext context;

  Responsive(this.context);

  // Screen size getters
  Size get size => MediaQuery.of(context).size;
  double get width => size.width;
  double get height => size.height;

  // Device type checks
  bool get isMobile => width < 600;
  bool get isTablet => width >= 600 && width < 1200;
  bool get isDesktop => width >= 1200;

  // Small phone detection (iPhone SE, etc.)
  bool get isSmallPhone => width < 360;

  // Responsive font size
  double fontSize(double baseSize) {
    if (isSmallPhone) return baseSize * 0.85;
    if (isTablet) return baseSize * 1.1;
    if (isDesktop) return baseSize * 1.2;
    return baseSize;
  }

  // Responsive padding
  double padding(double baseSize) {
    if (isSmallPhone) return baseSize * 0.85;
    if (isTablet) return baseSize * 1.15;
    if (isDesktop) return baseSize * 1.3;
    return baseSize;
  }

  // Responsive icon size
  double iconSize(double baseSize) {
    if (isSmallPhone) return baseSize * 0.9;
    if (isTablet) return baseSize * 1.1;
    return baseSize;
  }

  // Screen padding based on device
  double get screenPadding {
    if (isSmallPhone) return 16;
    if (isTablet) return 32;
    if (isDesktop) return 48;
    return 20;
  }

  // Card width for horizontal lists
  double get cardWidth {
    if (isSmallPhone) return width * 0.75;
    if (isTablet) return 280;
    return 260;
  }

  // Grid column count
  int get gridColumns {
    if (isDesktop) return 4;
    if (isTablet) return 3;
    return 2;
  }
}

// Extension for easy access
extension ResponsiveExtension on BuildContext {
  Responsive get responsive => Responsive(this);
}
