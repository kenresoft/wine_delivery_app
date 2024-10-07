import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/theme/theme_cubit.dart';

class ThemeSettingsDialog extends StatelessWidget {
  const ThemeSettingsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Theme Settings'),
      content: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeState) {
          return SizedBox(
            width: 300,
            child: ListView(
              shrinkWrap: true,
              children: [
                ListTile(
                  title: const Text('Light Theme'),
                  onTap: () {
                    context.read<ThemeCubit>().updateTheme(ThemeMode.light);
                    Navigator.pop(context);
                  },
                  trailing: themeState == ThemeMode.light ? const Icon(Icons.check) : null,
                ),
                ListTile(
                  title: const Text('Dark Theme'),
                  onTap: () {
                    context.read<ThemeCubit>().updateTheme(ThemeMode.dark);
                    Navigator.pop(context);
                  },
                  trailing: themeState == ThemeMode.dark ? const Icon(Icons.check) : null,
                ),
                ListTile(
                  title: const Text('System Theme'),
                  onTap: () {
                    context.read<ThemeCubit>().updateTheme(ThemeMode.system);
                    Navigator.pop(context);
                  },
                  trailing: themeState == ThemeMode.system ? const Icon(Icons.check) : null,
                ),
              ],
            ),
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}