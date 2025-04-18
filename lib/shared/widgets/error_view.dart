import 'package:flutter/material.dart';

/// A standardized error display widget with retry functionality.
///
/// This widget presents error messages with a consistent UI pattern and
/// provides a retry action for error recovery scenarios.
class ErrorView extends StatelessWidget {
  /// The error message to display to the user.
  final String message;

  /// Callback function executed when the user taps the retry button.
  final VoidCallback onRetry;

  /// Optional icon to display above the error message.
  final IconData icon;

  /// Creates an [ErrorView] with required parameters.
  ///
  /// The [message] parameter provides context about the error.
  /// The [onRetry] callback allows for recovery actions.
  const ErrorView({
    super.key,
    required this.message,
    required this.onRetry,
    this.icon = Icons.error_outline,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: Colors.red.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}