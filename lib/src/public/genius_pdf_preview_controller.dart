import 'dart:typed_data';

import '../app/contracts/pdf_generation_ports.dart';
import '../compose/pdf_composition_root.dart';
import '../ui/controllers/preview_action_controller.dart';

/// Backward-compatible preview controller.
///
/// The public wrapper keeps the original const/optional constructor while
/// delegating behavior to a controller that depends only on application ports.
class GeniusPdfPreviewController {
  const GeniusPdfPreviewController({
    GeniusPdfFileGateway? files,
    GeniusPdfInteractionGateway? interactions,
  })  : _files = files,
        _interactions = interactions;

  final GeniusPdfFileGateway? _files;
  final GeniusPdfInteractionGateway? _interactions;

  GeniusPdfPreviewActionController get _delegate {
    if (_files == null && _interactions == null) {
      return GeniusPdfCompositionRoot.defaults.previewController;
    }
    return GeniusPdfPreviewActionController(
      files: _files ?? GeniusPdfCompositionRoot.defaults.files,
      interactions:
          _interactions ?? GeniusPdfCompositionRoot.defaults.interactions,
    );
  }

  Future<void> print(Uint8List bytes, String documentName) =>
      _delegate.print(bytes, documentName);

  Future<void> share(Uint8List bytes, String fileName) =>
      _delegate.share(bytes, fileName);

  Future<String> download(Uint8List bytes, String fileName) =>
      _delegate.download(bytes, fileName);

  Future<Uint8List> readFile(String path) => _delegate.readFile(path);
}
