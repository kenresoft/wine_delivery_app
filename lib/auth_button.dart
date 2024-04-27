import 'package:flutter/material.dart';
import 'package:wine_delivery_app/utils/app_theme.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({
    super.key,
    required this.text,
    required this.icon,
  });

  final String text;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        // Handle Google sign-in
      },
      style: OutlinedButton.styleFrom(
        maximumSize: const Size(260, 52),
      ),
      child: SizedBox(
        height: 52,
        child: Row(
          children: [
            Icon(
              icon.icon,
              color: AppTheme().themeData.iconTheme.color,
            ),
            const SizedBox(width: 12),
            Text(text),
          ],
        ),
      ),
    );
  }
}
