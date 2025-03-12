import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:vintiora/core/router/nav.dart';
import 'package:vintiora/core/theme/app_button_theme.dart';
import 'package:vintiora/core/theme/app_theme.dart';
import 'package:vintiora/shared/components/app_wrapper.dart';

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

  const ErrorPage({
    super.key,
    required this.message,
    required this.errorType,
    required this.onRetry,
    this.actionText,
  });

  @override
  State<ErrorPage> createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  final TextEditingController _issueController = TextEditingController();
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    )..forward();
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _issueController.dispose();
    _controller.dispose();
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
                    'Oops! Something went wrong.',
                    textAlign: TextAlign.center,
                    style: theme(context).textTheme.displayLarge,
                  ),
                  const SizedBox(height: 32),
                  Text(
                    widget.message,
                    // _getErrorMessage(widget.message),
                    style: theme(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 16,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _isLoading = true; // Show loading indicator
                      });
                      await widget.onRetry(); // Call the retry function
                      setState(() {
                        _isLoading = false; // Hide loading indicator
                      });
                    },
                    style: AppButtonTheme.elevatedButton,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white) // Show loading indicator on button
                        : Text(widget.actionText ?? 'Retry'),
                  ),
                  const SizedBox(height: 32),
                  TextButton(
                    onPressed: () {
                      _reportIssue(context);
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: theme(context).colorScheme.surfaceTint,
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    child: const Text('Report Issue'),
                  ),
                  if (_isLoading) const CircularProgressIndicator(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getErrorMessage(String errorMessage) {
    switch (widget.errorType) {
      case ErrorType.route:
        return 'The current route is not defined. Please navigate to home.';
      case ErrorType.network:
        return 'It seems there is a network issue. Please check your internet connection.';
      case ErrorType.timeout:
        return 'The operation timed out. Please try again.';
      case ErrorType.authentication:
        return 'Authentication failed. Please check your credentials.';
      case ErrorType.permission:
        return 'You do not have permission to perform this action.';
      case ErrorType.initialization:
        return 'Error during initialization. \n$errorMessage';
      case ErrorType.unknown:
      default:
        return widget.message.isNotEmpty ? widget.message : 'An unknown error occurred. Please try again later.';
    }
  }

  void _reportIssue(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Report Issue'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Please describe the issue you encountered:'),
              const SizedBox(height: 8),
              TextField(
                controller: _issueController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Type your message here',
                  border: OutlineInputBorder(),
                  labelText: 'Issue Description',
                ),
                // accessibilityHint: 'Type the issue description you encountered.',
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: _isLoading
                  ? null
                  : () {
                      if (_validateInput(_issueController.text)) {
                        _confirmReport(context, _issueController.text);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Please enter a valid message (1-250 characters, alphanumeric).'),
                        ));
                      }
                    },
              child: const Text('Submit'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
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
          content: const Text('Are you sure you want to submit this report?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _submitReport(issue);
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }

  bool _validateInput(String input) {
    final regex = RegExp(r'^[a-zA-Z0-9\s.,?!-]*$'); // Allow alphanumeric and basic punctuation
    return input.isNotEmpty && input.length <= 250 && regex.hasMatch(input);
  }

  Future<void> _submitReport(String issue) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('https://phunplan.com/report'),
        body: {'issue': issue},
      );

      if (response.statusCode == 200) {
        Nav.showSnackBar('Issue reported successfully!');
      } else {
        _handleServerError(response.statusCode);
      }
    } catch (error) {
      _handleNetworkError(error);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handleServerError(int statusCode) {
    String message;
    switch (statusCode) {
      case 400:
        message = 'Bad request. Please check your input and try again.';
        break;
      case 404:
        message = 'Not found. The issue reporting endpoint may be unavailable.';
        break;
      case 500:
        message = 'Server error. Please try again later.';
        break;
      default:
        message = 'Unexpected error: $statusCode. Please try again.';
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  void _handleNetworkError(Object error) {
    String message;
    if (error is http.ClientException) {
      message = 'Network error: Unable to connect. Please check your internet connection.';
    } else {
      message = 'Unexpected error: $error. Please try again.';
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}
