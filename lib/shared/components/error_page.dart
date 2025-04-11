import 'dart:convert';

import 'package:extensionresoft/extensionresoft.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:vintiora/core/router/nav.dart';
import 'package:vintiora/core/theme/app_button_theme.dart';
import 'package:vintiora/core/theme/app_theme.dart';
import 'package:vintiora/core/utils/constants.dart';
import 'package:vintiora/shared/components/app_wrapper.dart';
import 'package:vintiora/shared/widgets/custom_text_field.dart';

enum ErrorType {
  route,
  network,
  timeout,
  unknown,
  authentication,
  permission,
  initialization,
}

class ErrorPage extends StatefulWidget {
  final String message;
  final ErrorType errorType;
  final Future<void> Function() onRetry;
  final String? actionText;
  final dynamic error;
  final StackTrace? stackTrace;

  const ErrorPage({
    super.key,
    required this.message,
    this.errorType = ErrorType.unknown,
    required this.onRetry,
    this.actionText,
    this.error,
    this.stackTrace,
  });

  @override
  State<ErrorPage> createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> with SingleTickerProviderStateMixin {
  final ValueNotifier<bool> _isLoadingNotifier = ValueNotifier<bool>(false);
  final TextEditingController _issueController = TextEditingController();
  late AnimationController _controller;
  late Animation<double> _animation;
  PackageInfo? _packageInfo;
  bool _showTechnicalDetails = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    )..forward();
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    _packageInfo = await PackageInfo.fromPlatform();
  }

  @override
  void dispose() {
    _issueController.dispose();
    _controller.dispose();
    _isLoadingNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return FadeTransition(
      opacity: _animation,
      child: AppWrapper(
        backgroundColor: theme(context).scaffoldBackgroundColor,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.exclamationmark_triangle,
                    size: 96,
                    color: theme(context).colorScheme.error,
                  ),
                  const SizedBox(height: 64),
                  Text(
                    _getErrorTitle(),
                    textAlign: TextAlign.center,
                    style: theme(context).textTheme.displayLarge?.copyWith(
                          fontSize: 24,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _getErrorMessage(widget.message),
                    style: theme(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 16,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  if (widget.error != null || widget.stackTrace != null)
                    Column(
                      children: [
                        OutlinedButton(
                          onPressed: () => setState(() => _showTechnicalDetails = !_showTechnicalDetails),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: theme(context).colorScheme.onSurface,
                            side: BorderSide(color: theme(context).colorScheme.outline),
                          ),
                          child: Text(
                            _showTechnicalDetails ? 'Hide Technical Details' : 'Show Technical Details',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (_showTechnicalDetails)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: theme(context).colorScheme.surfaceVariant,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (widget.error != null)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Error:',
                                        style: theme(context).textTheme.bodySmall?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: theme(context).colorScheme.error,
                                            ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        widget.error.toString(),
                                        style: theme(context).textTheme.bodySmall,
                                      ),
                                      const SizedBox(height: 12),
                                    ],
                                  ),
                                if (widget.stackTrace != null)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Stack Trace:',
                                        style: theme(context).textTheme.bodySmall?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: theme(context).colorScheme.error,
                                            ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        widget.stackTrace.toString(),
                                        style: theme(context).textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  const SizedBox(height: 16),
                  ValueListenableBuilder<bool>(
                    valueListenable: _isLoadingNotifier,
                    builder: (context, isLoading, _) {
                      return SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () async {
                                  _isLoadingNotifier.value = true;
                                  try {
                                    await widget.onRetry();
                                  } finally {
                                    _isLoadingNotifier.value = false;
                                  }
                                },
                          style: AppButtonTheme.elevatedButton,
                          child: isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  ),
                                )
                              : Text(
                                  widget.actionText ?? 'Try Again',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  ValueListenableBuilder<bool>(
                    valueListenable: _isLoadingNotifier,
                    builder: (context, isLoading, _) {
                      return SizedBox(
                        height: 48,
                        child: OutlinedButton(
                          onPressed: isLoading ? null : () => _reportIssue(context),
                          style: AppButtonTheme.outlinedErrorButton,
                          child: const Text(
                            'Report Issue',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getErrorTitle() {
    switch (widget.errorType) {
      case ErrorType.route:
        return 'Page Not Found';
      case ErrorType.network:
        return 'Connection Error';
      case ErrorType.timeout:
        return 'Request Timeout';
      case ErrorType.authentication:
        return 'Authentication Required';
      case ErrorType.permission:
        return 'Access Denied';
      case ErrorType.initialization:
        return 'Initialization Error';
      case ErrorType.unknown:
        return 'Something Went Wrong';
    }
  }

  String _getErrorMessage(String errorMessage) {
    String typeMessage;

    switch (widget.errorType) {
      case ErrorType.route:
        typeMessage = 'The page you requested could not be found. '
            'This may be due to an outdated link or the page being moved.';
        break;
      case ErrorType.network:
        typeMessage = 'We couldn\'t establish a connection to our servers. '
            'Please check your internet connection and try again.';
        break;
      case ErrorType.timeout:
        typeMessage = 'The request took too long to complete. '
            'This might be due to high server load or network latency. Please try again.';
        break;
      case ErrorType.authentication:
        typeMessage = 'Your session has expired or requires verification. '
            'Please sign in again to continue.';
        break;
      case ErrorType.permission:
        typeMessage = 'You don\'t have the required permissions to access this content. '
            'Please contact support if you believe this is an error.';
        break;
      case ErrorType.initialization:
        typeMessage = 'The application failed to initialize properly. '
            'This may require reinstalling the app or contacting support.';
        break;
      case ErrorType.unknown:
        typeMessage = 'An unexpected error occurred in the application. '
            'Our team has been notified and will investigate the issue.';
        break;
    }

    if (widget.message.isNotEmpty) {
      return widget.errorType == ErrorType.unknown ? widget.message : '$typeMessage\n\n${widget.message}';
    }

    return typeMessage;
  }

  void _reportIssue(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ValueListenableBuilder<bool>(
          valueListenable: _isLoadingNotifier,
          builder: (context, isLoading, _) {
            return AlertDialog(
              title: const Text('Report Issue'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Please describe what you were doing when the error occurred:',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      controller: _issueController,
                      hintText: 'Describe the issue...',
                      maxLines: 5,
                    ),
                    const SizedBox(height: 8),
                    if (widget.error != null || widget.stackTrace != null)
                      const Text(
                        'Technical details will be included in your report',
                        style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isLoading ? null : () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          if (_validateInput(_issueController.text)) {
                            _confirmReport(context, _issueController.text);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Please enter a description (1-500 characters)',
                                ),
                              ),
                            );
                          }
                        },
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Submit Report'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmReport(BuildContext context, String issue) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Submission'),
          content: const Text(
            'This will send the error details to our support team. '
            'Do you want to proceed?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _submitReport(issue);
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  bool _validateInput(String input) {
    return input.trim().isNotEmpty && input.length <= 500;
  }

  Future<void> _submitReport(String issue) async {
    _isLoadingNotifier.value = true;

    try {
      final reportData = {
        'description': issue,
        'error': widget.error?.toString(),
        'stackTrace': widget.stackTrace?.toString(),
        'errorType': widget.errorType.toString(),
        'appVersion': _packageInfo?.version,
        'buildNumber': _packageInfo?.buildNumber,
        'platform': Theme.of(context).platform.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      };

      logger.i(reportData);

      final response = await http.post(
        Uri.parse(ApiConstants.report),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(reportData),
      );

      if (response.statusCode == 200) {
        Nav.showSnackBar('Thank you! Your report has been submitted.');
      } else {
        _handleServerError(response.statusCode);
      }
    } catch (error) {
      _handleNetworkError(error);
    } finally {
      _isLoadingNotifier.value = false;
    }
  }

  void _handleServerError(int statusCode) {
    String message;
    switch (statusCode) {
      case 400:
        message = 'Invalid report data. Please try again with a different description.';
        break;
      case 429:
        message = 'Too many reports. Please try again later.';
        break;
      case 500:
        message = 'Our servers are experiencing issues. Please try again later.';
        break;
      default:
        message = 'Failed to submit report (Error $statusCode). Please try again.';
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleNetworkError(Object error) {
    const message = 'Network error: Unable to submit report. '
        'Please check your connection and try again.';
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
