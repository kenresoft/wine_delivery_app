import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vintiora/core/theme/app_colors.dart';
import 'package:vintiora/core/theme/app_theme.dart';

/// A self-managing wrapper widget that provides consistent styling and behavior
/// across the application, with smart defaults and automatic cleanup.
class AppWrapper extends StatefulWidget {
  final Widget child;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final bool includeMaterial;
  final bool useSafeArea;
  final bool resizeToAvoidBottomInset;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;

  /// Drawer and End Drawer support
  final Widget? drawer;
  final Widget? endDrawer;

  /// System UI configurations with theme-aware defaults
  final Color? statusBarColor;
  final Brightness? statusBarBrightness;
  final Brightness? statusBarIconBrightness;
  final List<DeviceOrientation>? allowedOrientations;

  const AppWrapper({
    super.key,
    required this.child,
    this.backgroundColor,
    this.padding,
    this.includeMaterial = true,
    this.useSafeArea = true,
    this.resizeToAvoidBottomInset = true,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.drawer,
    this.endDrawer,
    this.statusBarColor,
    this.statusBarBrightness,
    this.statusBarIconBrightness,
    this.allowedOrientations = const [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  });

  @override
  State<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  late List<DeviceOrientation> _previousOrientations;

  @override
  void initState() {
    super.initState();
    _previousOrientations = [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ];
    _applyOrientations();
  }

  @override
  void didUpdateWidget(AppWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.allowedOrientations != oldWidget.allowedOrientations) {
      _applyOrientations();
    }
  }

  @override
  void dispose() {
    // Restore previous orientations when disposed
    SystemChrome.setPreferredOrientations(_previousOrientations);
    super.dispose();
  }

  void _applyOrientations() {
    if (widget.allowedOrientations != null) {
      SystemChrome.setPreferredOrientations(widget.allowedOrientations!);
    }
  }

  SystemUiOverlayStyle _getSystemUiStyle(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return SystemUiOverlayStyle(
      statusBarColor: widget.statusBarColor ?? Colors.transparent,
      statusBarBrightness: widget.statusBarBrightness ?? brightness,
      statusBarIconBrightness: widget.statusBarIconBrightness ?? (isDark(context) ? Brightness.light : Brightness.dark),
      systemNavigationBarColor: isDark(context) ? AppColors.secondary : AppColors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _getSystemUiStyle(context),
      child: Builder(
        builder: (context) {
          Widget content = widget.child;

          if (widget.padding != null) {
            content = Padding(
              padding: widget.padding!,
              child: content,
            );
          }

          if (widget.useSafeArea) {
            content = SafeArea(child: content);
          }

          if (widget.includeMaterial) {
            content = Scaffold(
              // key: widget.key,
              resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
              backgroundColor: widget.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
              appBar: widget.appBar,
              body: content,
              bottomNavigationBar: widget.bottomNavigationBar,
              floatingActionButton: widget.floatingActionButton,
              drawer: widget.drawer,
              endDrawer: widget.endDrawer,
            );
          }

          return content;
        },
      ),
    );
  }
}
