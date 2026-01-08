import 'package:flutter/material.dart';
import 'package:loopx/theme/theme_controller.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ValueListenableBuilder<ThemeMode>(
          valueListenable: themeModeNotifier,
          builder: (context, mode, _) {
            return RadioGroup<ThemeMode>(
              groupValue: mode,
              onChanged: (value) {
                if (value != null) {
                  themeModeNotifier.value = value;
                }
              },
              child: Column(
                children: const [
                  RadioListTile(
                    value: ThemeMode.system,
                    title: Text('System default'),
                  ),
                  RadioListTile(
                    value: ThemeMode.light,
                    title: Text('Light mode'),
                  ),
                  RadioListTile(
                    value: ThemeMode.dark,
                    title: Text('Dark mode'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
