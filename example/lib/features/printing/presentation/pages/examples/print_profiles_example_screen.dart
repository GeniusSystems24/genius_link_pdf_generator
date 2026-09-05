import 'package:flutter/material.dart';
import 'package:genius_pdf_example/features/printing/presentation/controllers/printing_demo_controller.dart';
import 'package:genius_pdf_example/features/printing/presentation/internal/printing_single_example_host.dart';

class PrintProfilesExampleScreen extends StatelessWidget {
  const PrintProfilesExampleScreen({super.key, this.controller});
  final PrintingDemoController? controller;

  static const String dartUsageCode = r'''
void _saveCurrentSettings() {
    showDialog(
      context: context,
      builder: (context) {
        String name = '';
        return AlertDialog(
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? AppColors.darkSurface
              : AppColors.lightSurface,
          title: const Text('Save Profile'),
          content: TextField(
            decoration: const InputDecoration(
              labelText: 'Profile Name',
              hintText: 'e.g., My Office Settings',
            ),
            onChanged: (value) => name = value,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (name.isNotEmpty) {
                  _controller.saveProfile(name);
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

void _applyProfile(GeniusPrintProfile profile) =>
      _controller.applyProfile(profile);
''';

  @override
  Widget build(BuildContext context) {
    return PrintingSingleExampleHost(
      section: PrintingDemoSection.profiles,
      usageCode: dartUsageCode, controller: controller,
    );
  }
}
