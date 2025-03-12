import 'package:flutter/material.dart';

class CustomConfirmationDialog extends StatelessWidget {
  final String title;
  final String content;
  final String cancelButtonText;
  final String confirmButtonText;
  final VoidCallback? onCancel;
  final VoidCallback? onConfirm;

  const CustomConfirmationDialog({
    super.key,
    required this.title,
    required this.content,
    this.cancelButtonText = 'Cancel',
    this.confirmButtonText = 'Delete',
    this.onCancel,
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            if (onCancel != null) {
              onCancel!(); // Call the cancel callback
            }
            Navigator.of(context, rootNavigator: true).pop(false); // Close the dialog
          },
          child: Text(cancelButtonText),
        ),
        TextButton(
          onPressed: () {
            if (onConfirm != null) {
              onConfirm!(); // Call the confirm callback
            }
            Navigator.of(context, rootNavigator: true).pop(true); // Close the dialog
          },
          child: Text(confirmButtonText),
        ),
      ],
    );
  }
}
