import 'package:flutter/material.dart';

class QuantityButton extends StatelessWidget {
  final Function() onPressed;
  final IconData icon;

  const QuantityButton({
    super.key,
    required this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      constraints: BoxConstraints(minWidth: 25, minHeight: 25),
      style: ButtonStyle(
        shape: WidgetStatePropertyAll(CircleBorder()),
        backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.tertiary),
        // backgroundColor: WidgetStatePropertyAll(Colors.grey.shade300),
        iconSize: WidgetStatePropertyAll(20),
      ),
      icon: Icon(icon),
    );
  }
}