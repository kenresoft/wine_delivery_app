import 'package:flutter/material.dart';

/// A reusable loading indicator widget for consistent loading state representation
/// throughout the application.
class AppLoader extends StatelessWidget {
  /// Creates an [AppLoader] with optional size configuration.
  ///
  /// The [size] parameter determines the diameter of the loading indicator.
  /// Default is 24.0 logical pixels.
  final double size;

  /// The color of the loading indicator. If not provided, it will use the
  /// primary color from the current theme.
  final Color? color;

  const AppLoader({
    super.key,
    this.size = 24.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(
            color ?? Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}
