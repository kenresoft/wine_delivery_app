import 'package:flutter/material.dart';

/// Typedef for custom transition builder functions
typedef PageTransitionBuilder = Widget Function(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
);

/// Configuration for page transitions
class PageTransitionConfig {
  final PageTransitionBuilder? transitionsBuilder;
  final Duration duration;

  const PageTransitionConfig({
    this.transitionsBuilder,
    this.duration = const Duration(milliseconds: 300),
  });

  /// Fade transition preset
  static PageTransitionConfig fade({
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return PageTransitionConfig(
      duration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  /// Slide transition preset
  static PageTransitionConfig slide({
    Duration duration = const Duration(milliseconds: 300),
    AxisDirection direction = AxisDirection.right,
  }) {
    return PageTransitionConfig(
      duration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        Offset begin;
        switch (direction) {
          case AxisDirection.right:
            begin = const Offset(-1.0, 0.0);
            break;
          case AxisDirection.left:
            begin = const Offset(1.0, 0.0);
            break;
          case AxisDirection.up:
            begin = const Offset(0.0, 1.0);
            break;
          case AxisDirection.down:
            begin = const Offset(0.0, -1.0);
            break;
        }

        return SlideTransition(
          position: animation.drive(
            Tween(begin: begin, end: Offset.zero).chain(
              CurveTween(curve: Curves.easeInOut),
            ),
          ),
          child: child,
        );
      },
    );
  }
}
