import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vintiora/core/theme/app_button_theme.dart';
import 'package:vintiora/core/theme/app_colors.dart';
import 'package:vintiora/core/theme/app_theme.dart';
import 'package:vintiora/shared/widgets/app_divider.dart';

class DatePickerDialog extends StatefulWidget {
  final DateTime initialDate;
  final ValueChanged<DateTime> onChanged;

  const DatePickerDialog({
    super.key,
    required this.initialDate,
    required this.onChanged,
  });

  @override
  State<DatePickerDialog> createState() => _DatePickerDialogState();
}

class _DatePickerDialogState extends State<DatePickerDialog> {
  late ValueNotifier<DateTime> selectedDateNotifier;

  @override
  void initState() {
    super.initState();
    selectedDateNotifier = ValueNotifier<DateTime>(widget.initialDate);
  }

  @override
  void dispose() {
    selectedDateNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: theme(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)).r,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              alignment: Alignment.center,
              height: 56.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 40.h,
                    padding: const EdgeInsets.all(8).w,
                  ),
                  Text(
                    "Choose Date",
                    style: theme(context).textTheme.displayMedium?.copyWith(
                          color: isDark(context) ? Colors.white : AppColors.secondary,
                        ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            const AppDivider(),
            // Date Picker
            SizedBox(
              height: 200.h,
              child: ValueListenableBuilder<DateTime>(
                valueListenable: selectedDateNotifier,
                builder: (context, selectedDate, child) {
                  return Row(
                    children: [
                      _buildFadedEdgeScrollView(
                        controller: FixedExtentScrollController(
                          initialItem: selectedDate.month - 1,
                        ),
                        itemCount: 12,
                        itemBuilder: (context, index) {
                          final isActive = index == selectedDate.month - 1;
                          return Center(
                            child: Text(
                              _monthName(index + 1),
                              style: theme(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                                    color: isActive ? theme(context).secondaryHeaderColor : Colors.grey,
                                  ),
                            ),
                          );
                        },
                        onSelectedItemChanged: (index) {
                          selectedDateNotifier.value = DateTime(
                            selectedDate.year,
                            index + 1,
                            selectedDate.day,
                          );
                        },
                      ),
                      _buildFadedEdgeScrollView(
                        controller: FixedExtentScrollController(
                          initialItem: selectedDate.day - 1,
                        ),
                        itemCount: DateTime(selectedDate.year, selectedDate.month + 1, 0).day,
                        itemBuilder: (context, index) {
                          final isActive = index == selectedDate.day - 1;
                          return Center(
                            child: Text(
                              (index + 1).toString(),
                              style: theme(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                                    color: isActive ? theme(context).secondaryHeaderColor : Colors.grey,
                                  ),
                            ),
                          );
                        },
                        onSelectedItemChanged: (index) {
                          selectedDateNotifier.value = DateTime(
                            selectedDate.year,
                            selectedDate.month,
                            index + 1,
                          );
                        },
                      ),
                      _buildFadedEdgeScrollView(
                        controller: FixedExtentScrollController(
                          initialItem: DateTime.now().year - selectedDate.year,
                        ),
                        itemCount: 100,
                        itemBuilder: (context, index) {
                          final isActive = index == DateTime.now().year - selectedDate.year;
                          return Center(
                            child: Text(
                              (DateTime.now().year - index).toString(),
                              style: theme(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                                    color: isActive ? theme(context).secondaryHeaderColor : Colors.grey,
                                  ),
                            ),
                          );
                        },
                        onSelectedItemChanged: (index) {
                          selectedDateNotifier.value = DateTime(
                            DateTime.now().year - index,
                            selectedDate.month,
                            selectedDate.day,
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
            const AppDivider(),
            SizedBox(height: 8.h),
            // Set Date Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: AppButtonTheme.defaultElevatedButton,
                onPressed: () {
                  widget.onChanged(selectedDateNotifier.value);
                  Navigator.of(context).pop(selectedDateNotifier.value);
                },
                child: const Text("Set Date"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
    return months[month - 1];
  }

  Widget _buildFadedEdgeScrollView({
    required FixedExtentScrollController controller,
    required int itemCount,
    required IndexedWidgetBuilder itemBuilder,
    required void Function(int) onSelectedItemChanged,
  }) {
    return Expanded(
      child: ShaderMask(
        shaderCallback: (bounds) {
          return const LinearGradient(
            colors: [Colors.black, Colors.transparent, Colors.transparent, Colors.black],
            stops: [0.0, 0.25, 0.75, 1.0],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(bounds);
        },
        blendMode: BlendMode.dstOut,
        child: Stack(
          children: [
            ListWheelScrollView.useDelegate(
              controller: controller,
              itemExtent: 26.h,
              physics: const FixedExtentScrollPhysics(),
              onSelectedItemChanged: onSelectedItemChanged,
              childDelegate: ListWheelChildBuilderDelegate(
                builder: itemBuilder,
                childCount: itemCount,
              ),
            ),
            Positioned(
              top: 85.h,
              left: 0,
              right: 0,
              child: const AppDivider(),
            ),
            Positioned(
              bottom: 85.h,
              left: 0,
              right: 0,
              child: const AppDivider(),
            ),
          ],
        ),
      ),
    );
  }
}

void showDatePickerDialog(BuildContext context, ValueChanged<DateTime> onChanged) async {
  await showModalBottomSheet<DateTime>(
    context: context,
    isScrollControlled: true,
    builder: (_) => DatePickerDialog(
      initialDate: DateTime.now(),
      onChanged: onChanged,
    ),
  );
}
