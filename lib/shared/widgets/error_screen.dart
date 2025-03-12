import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vintiora/shared/components/error_page.dart';

class ErrorScreen extends StatefulWidget {
  final String message;
  final ErrorType errorType;
  final Future<void> Function() onRetry;
  final String? actionText;

  const ErrorScreen({
    super.key,
    required this.message,
    required this.errorType,
    required this.onRetry,
    this.actionText,
  });

  @override
  State<ErrorScreen> createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> with SingleTickerProviderStateMixin {
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
    return FadeTransition(
      opacity: _animation,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 100,
                    color: Colors.redAccent,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Oops! Something went wrong.',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.message,
                    // _getErrorMessage(widget.message),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
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
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      backgroundColor: Colors.blue,
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white) // Show loading indicator on button
                        : Text(widget.actionText ?? 'Retry'),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      _reportIssue(context);
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.redAccent,
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
                Navigator.of(context).pop(); // Close confirmation dialog
                _submitReport(issue);
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close confirmation dialog
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
        Uri.parse('https://example.com/report'), // Replace with your API endpoint
        body: {'issue': issue},
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Issue reported successfully!'),
        ));
        // Allow user to manually dismiss the dialog
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
