import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A wrapper widget for rendering SVG assets from local or network sources.
///
/// This widget simplifies SVG implementation by providing customizable options
/// like size, color, alignment, and fit.
class SvgWrapper extends StatelessWidget {
  /// Path to the SVG asset (local or network URL). This is a required parameter.
  final String path;

  /// Optional width of the SVG.
  final double? width;

  /// Optional height of the SVG.
  final double? height;

  /// Optional color for tinting the SVG. Defaults to no tint.
  final Color? color;

  /// Determines how the SVG should be inscribed into its bounds.
  /// Defaults to [BoxFit.contain].
  final BoxFit fit;

  /// Aligns the SVG within its container. Defaults to [Alignment.center].
  final Alignment alignment;

  /// Optional widget to display in case the SVG fails to load.
  final Widget? placeholder;

  /// Optional widget to display while the SVG is loading asynchronously.
  final Widget? loadingWidget;

  /// Determines whether the SVG is loaded from a network source.
  final bool isNetwork;

  const SvgWrapper(
    this.path, {
    super.key,
    this.width,
    this.height,
    this.color,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.placeholder,
    this.loadingWidget,
    this.isNetwork = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isNetwork) {
      return SvgPicture.network(
        path,
        width: width,
        height: height,
        colorFilter: color != null
            ? ColorFilter.mode(
                color!,
                BlendMode.srcIn,
              )
            : null,
        fit: fit,
        alignment: alignment,
        placeholderBuilder: (context) =>
            placeholder ??
            Center(
              child: SizedBox(
                width: width ?? 50,
                height: height ?? 50,
                child: loadingWidget ?? const CircularProgressIndicator(),
              ),
            ),
        semanticsLabel: 'Network SVG Image',
      );
    } else {
      return SvgPicture.asset(
        path,
        width: width,
        height: height,
        colorFilter: color != null
            ? ColorFilter.mode(
                color!,
                BlendMode.srcIn,
              )
            : null,
        fit: fit,
        alignment: alignment,
        placeholderBuilder: (context) =>
            placeholder ??
            Center(
              child: SizedBox(
                width: width ?? 50,
                height: height ?? 50,
                child: loadingWidget ?? const CircularProgressIndicator(),
              ),
            ),
        semanticsLabel: 'Asset SVG Image',
      );
    }
  }

  /// Factory method for creating a `SvgWrapper` for network SVGs.
  factory SvgWrapper.network(
    String url, {
    double? width,
    double? height,
    Color? color,
    BoxFit fit = BoxFit.contain,
    Alignment alignment = Alignment.center,
    Widget? placeholder,
    Widget? loadingWidget,
  }) {
    return SvgWrapper(
      url,
      isNetwork: true,
      width: width,
      height: height,
      color: color,
      fit: fit,
      alignment: alignment,
      placeholder: placeholder,
      loadingWidget: loadingWidget,
    );
  }
}
