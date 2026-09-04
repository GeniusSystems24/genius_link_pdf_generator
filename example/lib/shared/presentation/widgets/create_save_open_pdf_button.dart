
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:genius_pdf_example/app/dependencies/example_dependencies.dart';
import 'package:genius_pdf_example/shared/application/contracts/demo_file_gateway.dart';

/// Creates a fresh PDF, saves it, then opens the saved file.
///
/// This button is intended for manual-verification screens where previewing
/// bytes in-process is not enough to prove the full create → save → open path.
///
/// [onCreate] must create fresh PDF bytes for the screen's current scenario.
/// Persistence and platform opening are delegated to the example application's
/// existing [demoDocuments] controller rather than implemented in the view.
class CreateSaveOpenPdfButton extends StatefulWidget {
  const CreateSaveOpenPdfButton({
    required this.onCreate,
    required this.fileName,
    this.label = 'Create → Save → Open',
    this.location = DemoStorageLocation.temporary,
    super.key,
  });

  /// Creates fresh PDF bytes for the current verification scenario.
  final FutureOr<List<int>> Function() onCreate;

  /// File name used by the example file gateway.
  final String fileName;

  /// Button text when no operation is running.
  final String label;

  /// Storage target before the platform file opener is invoked.
  ///
  /// Temporary storage is the default because Sprint verification files are
  /// generated repeatedly and are not user-authored documents.
  final DemoStorageLocation location;

  @override
  State<CreateSaveOpenPdfButton> createState() =>
      _CreateSaveOpenPdfButtonState();
}

class _CreateSaveOpenPdfButtonState
    extends State<CreateSaveOpenPdfButton> {
  bool _busy = false;

  Future<void> _createSaveOpen() async {
    if (_busy) return;

    setState(() {
      _busy = true;
    });

    try {
      // Deliberately create fresh bytes instead of reusing the preview Future.
      final bytes = await widget.onCreate();

      if (bytes.isEmpty) {
        throw StateError('Generated PDF is empty.');
      }

      final path = await demoDocuments.saveAndOpen(
        bytes: bytes,
        fileName: widget.fileName,
        location: widget.location,
      );

      if (!mounted) return;
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(
          content: Text('Created, saved and opened:\n$path'),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(
          content: Text('Create → Save → Open failed:\n$error'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _busy = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: _busy ? null : _createSaveOpen,
      icon: _busy
          ? const SizedBox.square(
              dimension: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.open_in_new_rounded),
      label: Text(_busy ? 'Creating PDF…' : widget.label),
    );
  }
}
