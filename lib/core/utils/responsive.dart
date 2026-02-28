import 'package:flutter/material.dart';

extension ResponsiveContext on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  // Responsive width (based on 375.0 design width)
  double rw(double value) {
    if (screenWidth > 600) return value * 1.5; // Cap for tablet/desktop
    return (value / 375.0) * screenWidth;
  }

  // Responsive height (based on 812.0 design height)
  double rh(double value) {
    if (screenHeight > 1000) return value * 1.5;
    return (value / 812.0) * screenHeight;
  }

  // Responsive font size
  double sp(double value) {
    if (screenWidth > 600) return value * 1.2; // Slightly larger on tablets/desktop
    return (value / 375.0) * screenWidth;
  }
}

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const Responsive({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 1100;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1100;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    if (size.width >= 1100) {
      return desktop;
    } else if (size.width >= 600 && tablet != null) {
      return tablet!;
    } else {
      return mobile;
    }
  }
}
