import 'package:flutter/material.dart';

class FlashSaleTimer extends StatelessWidget {
  final int timeRemainingInSeconds;
  final Color textColor;
  final Color backgroundColor;
  final double fontSize;
  final bool showLabels;

  const FlashSaleTimer({
    super.key,
    required this.timeRemainingInSeconds,
    this.textColor = Colors.white,
    this.backgroundColor = Colors.redAccent,
    this.fontSize = 14.0,
    this.showLabels = true,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate hours, minutes, seconds
    final hours = timeRemainingInSeconds ~/ 3600;
    final minutes = (timeRemainingInSeconds % 3600) ~/ 60;
    final seconds = timeRemainingInSeconds % 60;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildTimeUnit(hours.toString().padLeft(2, '0'), 'HRS'),
        _buildSeparator(),
        _buildTimeUnit(minutes.toString().padLeft(2, '0'), 'MIN'),
        _buildSeparator(),
        _buildTimeUnit(seconds.toString().padLeft(2, '0'), 'SEC'),
      ],
    );
  }

  Widget _buildTimeUnit(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
            ),
          ),
          if (showLabels)
            Text(
              label,
              style: TextStyle(
                color: textColor.withOpacity(0.8),
                fontSize: fontSize * 0.6,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSeparator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Text(
        ':',
        style: TextStyle(
          color: backgroundColor,
          fontWeight: FontWeight.bold,
          fontSize: fontSize * 1.2,
        ),
      ),
    );
  }
}