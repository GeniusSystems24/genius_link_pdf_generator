import '../infra/printer_preview_gateway.dart';
import '../ui/print_preview_controller.dart';

abstract final class GeniusPrintingCompositionRoot {
  static const GeniusPrintPreviewController previewController =
      GeniusPrintPreviewController(
    gateway: GeniusPrinterServicePreviewGateway(),
  );
}
