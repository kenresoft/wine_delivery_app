import 'package:flutter/material.dart';
import 'package:vintiora/core/utils/constants.dart';
import 'package:vintiora/core/utils/helpers.dart';
import 'package:vintiora/shared/components/app_wrapper.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    required this.tablet,
    required this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    isMobile;
    return AppWrapper(
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= Constants.desktopBreakPoint) {
            return desktop;
          } else if (constraints.maxWidth >= Constants.mobileBreakPoint) {
            return tablet;
          } else {
            return mobile;
          }
        },
      ),
    );
  }
}
