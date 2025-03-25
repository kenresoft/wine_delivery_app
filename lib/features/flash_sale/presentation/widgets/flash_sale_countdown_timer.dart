import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vintiora/core/theme/app_colors.dart';

class FlashSaleCountdownTimer extends StatefulWidget {
  final int hours;
  final int minutes;
  final int seconds;
  final Color? textColor;
  final double? fontSize;
  final bool showLabels;
  final VoidCallback? onTimerComplete;

  const FlashSaleCountdownTimer({
    super.key,
    required this.hours,
    required this.minutes,
    required this.seconds,
    this.textColor,
    this.fontSize = 14,
    this.showLabels = true,
    this.onTimerComplete,
  });

  @override
  State<FlashSaleCountdownTimer> createState() => _FlashSaleCountdownTimerState();
}

class _FlashSaleCountdownTimerState extends State<FlashSaleCountdownTimer> {
  late int _hours;
  late int _minutes;
  late int _seconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _hours = widget.hours;
    _minutes = widget.minutes;
    _seconds = widget.seconds;
    _startTimer();
  }

  @override
  void didUpdateWidget(covariant FlashSaleCountdownTimer oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If the timer values have changed from external props
    if (oldWidget.hours != widget.hours || oldWidget.minutes != widget.minutes || oldWidget.seconds != widget.seconds) {
      _stopTimer();
      _hours = widget.hours;
      _minutes = widget.minutes;
      _seconds = widget.seconds;
      _startTimer();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_seconds > 0) {
          _seconds--;
        } else {
          if (_minutes > 0) {
            _minutes--;
            _seconds = 59;
          } else {
            if (_hours > 0) {
              _hours--;
              _minutes = 59;
              _seconds = 59;
            } else {
              _timer?.cancel();
              if (widget.onTimerComplete != null) {
                widget.onTimerComplete!();
              }
            }
          }
        }
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildTimeUnit(_hours.toString().padLeft(2, '0'), 'HRS'),
        _buildSeparator(),
        _buildTimeUnit(_minutes.toString().padLeft(2, '0'), 'MIN'),
        _buildSeparator(),
        _buildTimeUnit(_seconds.toString().padLeft(2, '0'), 'SEC'),
      ],
    );
  }

  Widget _buildTimeUnit(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.darkPrimary,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TextStyle(
              color: widget.textColor ?? Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: widget.fontSize,
            ),
          ),
          if (widget.showLabels)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                label,
                style: TextStyle(
                  color: widget.textColor?.withOpacity(0.8),
                  fontSize: widget.fontSize != null ? widget.fontSize! * 0.6 : 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSeparator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        ':',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: widget.fontSize,
        ),
      ),
    );
  }
}
