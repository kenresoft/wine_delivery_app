import 'package:flutter/material.dart';
import 'package:vintiora/core/theme/app_colors.dart';
import 'package:vintiora/core/theme/app_theme.dart';

class Breadcrumb extends StatelessWidget {
  final List<BreadcrumbItem> items;

  const Breadcrumb({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: items.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (item.onTap != null)
              InkWell(
                onTap: item.onTap,
                child: Text(
                  item.label,
                  style: theme(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.primary,
                        decorationColor: AppColors.primary,
                        decoration: TextDecoration.underline,
                      ),
                ),
              )
            else
              Text(
                item.label,
                style: theme(context).textTheme.titleMedium?.copyWith(
                      color: theme(context).secondaryHeaderColor,
                    ),
              ),
            if (index < items.length - 1)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(Icons.chevron_right, size: 16),
              ),
          ],
        );
      }).toList(),
    );
  }
}

class BreadcrumbItem {
  final String label;
  final VoidCallback? onTap;

  const BreadcrumbItem({
    required this.label,
    this.onTap,
  });
}
